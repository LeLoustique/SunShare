import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/token_storage.dart';
import 'package:sunshare/features/auth/auth_repository.dart';
import 'package:sunshare/features/meters/meters_repository.dart';
import 'package:sunshare/main.dart';
import 'package:sunshare_api/sunshare_api.dart';

const validPassword = 'motdepasse123';

final camille = UserOut((b) => b
  ..id = '0b4c8a1e-0000-4000-8000-000000000001'
  ..email = 'camille@exemple.fr'
  ..firstName = 'Camille'
  ..lastName = 'Martin'
  ..role = UserRole.producer
  ..createdAt = DateTime.utc(2026, 10, 28, 9));

/// Erreur telle que la renvoie le client généré quand l'API répond `{"detail": ...}`.
DioException apiError(int status, String detail) {
  final options = RequestOptions(path: '/');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: status, data: {'detail': detail}),
  );
}

class MemoryTokenStorage implements TokenStorage {
  MemoryTokenStorage([this.tokens]);

  Tokens? tokens;

  @override
  Future<Tokens?> read() async => tokens;

  @override
  Future<void> save(Tokens tokens) async => this.tokens = tokens;

  @override
  Future<void> clear() async => tokens = null;
}

/// Démarre l'application complète sur des dépôts simulés (aucun appel réseau).
Future<void> pumpApp(
  WidgetTester tester, {
  required FakeAuthRepository auth,
  FakeMetersRepository? meters,
}) async {
  // Écran assez haut pour que les formulaires tiennent sans défilement
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      metersRepositoryProvider.overrideWithValue(meters ?? FakeMetersRepository()),
    ],
    child: const SunShareApp(),
  ));
  await tester.pumpAndSettle();
}

/// Simule l'API : un seul compte (camille@exemple.fr / motdepasse123), producteur par défaut.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.loggedIn = false, UserRole? role})
      : user = camille.rebuild((b) => b..role = role ?? UserRole.producer);

  bool loggedIn;
  final UserOut user;
  UserCreate? registered;

  @override
  Future<UserOut?> restoreSession() async => loggedIn ? user : null;

  @override
  Future<UserOut> login(String email, String password) async {
    if (email.trim() != camille.email || password != validPassword) {
      throw apiError(401, 'E-mail ou mot de passe incorrect');
    }
    loggedIn = true;
    return user;
  }

  @override
  Future<UserOut> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    if (email.trim() == camille.email) {
      throw apiError(409, 'Un compte existe déjà avec cet e-mail');
    }
    registered = UserCreate((b) => b
      ..email = email
      ..password = password
      ..firstName = firstName
      ..lastName = lastName
      ..role = role);
    loggedIn = true;
    return camille.rebuild((b) => b
      ..email = email
      ..firstName = firstName
      ..lastName = lastName
      ..role = role);
  }

  @override
  Future<UserOut> me() async => user;

  @override
  Future<void> logout() async => loggedIn = false;
}

final amiens = AddressSuggestion((b) => b
  ..label = '8 Boulevard du Port 80000 Amiens'
  ..postcode = '80000'
  ..city = 'Amiens'
  ..latitude = 49.897442
  ..longitude = 2.290084);

/// Simule /meters et /addresses : ne connaît que l'adresse [amiens].
class FakeMetersRepository implements MetersRepository {
  FakeMetersRepository([List<MeterOut>? meters]) : meters = meters ?? [];

  final List<MeterOut> meters;
  final searches = <String>[];

  @override
  Future<List<MeterOut>> list() async => List.of(meters);

  @override
  Future<MeterOut> create({
    required String prm,
    required MeterDirection direction,
    required String address,
    num? peakKw,
  }) async {
    if (meters.any((m) => m.prm == prm && m.direction == direction)) {
      throw apiError(409, 'Ce compteur est déjà enregistré');
    }
    final meter = MeterOut((b) => b
      ..id = 'compteur-${meters.length + 1}'
      ..prm = prm
      ..direction = direction
      ..address = address
      ..latitude = amiens.latitude
      ..longitude = amiens.longitude
      ..peakKw = peakKw
      ..createdAt = DateTime.utc(2026, 10, 28));
    meters.add(meter);
    return meter;
  }

  @override
  Future<void> delete(String id) async => meters.removeWhere((m) => m.id == id);

  @override
  Future<List<AddressSuggestion>> searchAddresses(String query) async {
    searches.add(query);
    return query.toLowerCase().contains('port') ? [amiens] : [];
  }
}

MeterOut meter({
  required String prm,
  MeterDirection? direction,
  num? peakKw,
}) =>
    MeterOut((b) => b
      ..id = 'compteur-$prm'
      ..prm = prm
      ..direction = direction ?? MeterDirection.consumption
      ..address = amiens.label
      ..latitude = amiens.latitude
      ..longitude = amiens.longitude
      ..peakKw = peakKw
      ..createdAt = DateTime.utc(2026, 10, 28));
