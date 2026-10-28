import 'package:dio/dio.dart';
import 'package:sunshare/core/token_storage.dart';
import 'package:sunshare/features/auth/auth_repository.dart';
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

/// Simule l'API : un seul compte (camille@exemple.fr / motdepasse123).
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.loggedIn = false});

  bool loggedIn;
  UserCreate? registered;

  @override
  Future<UserOut?> restoreSession() async => loggedIn ? camille : null;

  @override
  Future<UserOut> login(String email, String password) async {
    if (email.trim() != camille.email || password != validPassword) {
      throw apiError(401, 'E-mail ou mot de passe incorrect');
    }
    loggedIn = true;
    return camille;
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
  Future<UserOut> me() async => camille;

  @override
  Future<void> logout() async => loggedIn = false;
}
