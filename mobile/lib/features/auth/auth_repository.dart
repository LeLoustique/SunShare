import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';
import '../../core/token_storage.dart';

class AuthRepository {
  AuthRepository(this._api, this._storage);

  final SunshareApi _api;
  final TokenStorage _storage;

  /// Au démarrage : utilisateur de la session enregistrée, ou null s'il n'y en a pas (ou plus).
  Future<UserOut?> restoreSession() async {
    if (await _storage.read() == null) return null;
    try {
      return await me();
    } on DioException catch (e) {
      // 401 malgré la tentative de rafraîchissement : session expirée
      if (e.response?.statusCode == 401) {
        await _storage.clear();
        return null;
      }
      rethrow;
    }
  }

  Future<UserOut> login(String email, String password) async {
    final pair = (await _api.getAuthApi().login(username: email.trim(), password: password)).data!;
    await _storage.save(Tokens(pair.accessToken, pair.refreshToken));
    return me();
  }

  /// Crée le compte puis connecte directement l'utilisateur.
  Future<UserOut> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    await _api.getAuthApi().register(
          userCreate: UserCreate((b) => b
            ..email = email.trim()
            ..password = password
            ..firstName = firstName.trim()
            ..lastName = lastName.trim()
            ..role = role),
        );
    return login(email, password);
  }

  Future<UserOut> me() async => (await _api.getProfilApi().readMe()).data!;

  /// Pas de révocation côté serveur pour l'instant : on oublie simplement les jetons.
  Future<void> logout() => _storage.clear();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiProvider), ref.watch(tokenStorageProvider)),
);
