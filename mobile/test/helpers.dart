import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/token_storage.dart';
import 'package:sunshare/features/auth/auth_repository.dart';
import 'package:sunshare/features/loops/loops_repository.dart';
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
  FakeLoopsRepository? loops,
}) async {
  // Écran assez haut pour que les formulaires tiennent sans défilement
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final metersRepository = meters ?? FakeMetersRepository();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      metersRepositoryProvider.overrideWithValue(metersRepository),
      loopsRepositoryProvider.overrideWithValue(loops ?? FakeLoopsRepository(metersRepository)),
    ],
    child: const SunShareApp(),
  ));
  await tester.pumpAndSettle();
}

/// L'accueil est « Ma boucle » : ouvre l'onglet Profil.
Future<void> goToProfile(WidgetTester tester) async {
  await tester.tap(find.text('Profil'));
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

AvailableLoop availableLoop({
  String id = 'boucle-1',
  String name = 'Saint-Leu',
  String price = '0.1800',
  required List<String> joinable,
}) =>
    AvailableLoop((b) => b
      ..id = id
      ..name = name
      ..perimeterKm = 2
      ..priceEurKwh = price
      ..memberCount = 3
      ..joinableMeterIds.addAll(joinable));

LoopOut loopOut({String id = 'boucle-1', String name = 'Saint-Leu'}) => LoopOut((b) => b
  ..id = id
  ..name = name
  ..perimeterKm = 2
  ..priceEurKwh = '0.1800'
  ..status = LoopStatus.open
  ..stats.memberCount = 3
  ..stats.producerCount = 1
  ..stats.consumerCount = 2
  ..stats.totalPeakKw = 9
  ..stats.diameterKm = 0.814);

MembershipOut membership(
  MeterOut meter, {
  String loopId = 'boucle-1',
  String loopName = 'Saint-Leu',
  MembershipStatus? status,
  Date? joinedAt,
}) =>
    MembershipOut((b) => b
      ..id = 'adhesion-${meter.id}-$loopId'
      ..loopId = loopId
      ..loopName = loopName
      ..meterId = meter.id
      ..prm = meter.prm
      ..direction = meter.direction
      ..status = status ?? MembershipStatus.pending
      ..requestedAt = DateTime.utc(2026, 10, 28)
      ..joinedAt = joinedAt);

/// Simule /loops et /me/memberships. Une adhésion crée une demande en attente ; [refusedLoops]
/// répondent 409 (hors périmètre).
class FakeLoopsRepository implements LoopsRepository {
  FakeLoopsRepository(
    this._meters, {
    List<AvailableLoop>? available,
    List<MembershipOut>? memberships,
    this.refusedLoops = const {},
  })  : availableLoops = available ?? [],
        membershipList = memberships ?? [];

  final FakeMetersRepository _meters;
  final List<AvailableLoop> availableLoops;
  final List<MembershipOut> membershipList;
  final Set<String> refusedLoops;

  bool _engaged(String meterId) =>
      membershipList.any((m) => m.meterId == meterId && isEngaged(m));

  @override
  Future<List<AvailableLoop>> available() async => [
        for (final loop in availableLoops)
          if (loop.joinableMeterIds.any((id) => !_engaged(id)))
            loop.rebuild((b) => b.joinableMeterIds.where((id) => !_engaged(id))),
      ];

  @override
  Future<List<MembershipOut>> memberships() async => List.of(membershipList);

  @override
  Future<LoopOut> loop(String id) async {
    final name = membershipList.firstWhere((m) => m.loopId == id).loopName;
    return loopOut(id: id, name: name);
  }

  @override
  Future<MembershipOut> join(String loopId, String meterId) async {
    if (refusedLoops.contains(loopId)) {
      throw apiError(409, 'Votre compteur est hors du périmètre de la boucle');
    }
    final loop = availableLoops.firstWhere((l) => l.id == loopId);
    final meter = _meters.meters.firstWhere((m) => m.id == meterId);
    final created = membership(meter, loopId: loopId, loopName: loop.name);
    membershipList.insert(0, created);
    return created;
  }

  @override
  Future<void> cancel(String membershipId) async =>
      membershipList.removeWhere((m) => m.id == membershipId);
}
