import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'auth_repository.dart';

/// Utilisateur connecté (null si déconnecté). Le routeur redirige selon cet état.
///
/// login / register ne passent pas l'état en chargement : chaque écran gère son propre indicateur,
/// et les erreurs remontent à l'écran qui les affiche.
class AuthController extends AsyncNotifier<UserOut?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<UserOut?> build() => _repository.restoreSession();

  Future<void> login(String email, String password) async {
    state = AsyncData(await _repository.login(email, password));
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    state = AsyncData(await _repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
    ));
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(null);
  }

  /// Jeton de rafraîchissement refusé par l'API (expiré ou compte supprimé).
  void sessionExpired() {
    if (state.value != null) state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserOut?>(AuthController.new);
