import 'package:dio/dio.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'token_storage.dart';

/// Ajoute `Authorization: Bearer` aux routes protégées et, sur une 401, renouvelle le jeton d'accès
/// (valable 15 min) puis rejoue la requête une seule fois.
///
/// QueuedInterceptor : les erreurs sont traitées une par une, donc plusieurs 401 simultanées ne
/// déclenchent qu'un seul rafraîchissement. Le rafraîchissement et le rejeu passent par [plainDio]
/// (sans intercepteur), sinon un rejeu en 401 attendrait sa propre file : blocage.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.plainDio, required this.storage, required this.onSessionExpired})
      : _authApi = SunshareApi(dio: plainDio, interceptors: []).getAuthApi();

  final Dio plainDio;
  final TokenStorage storage;

  /// Appelé quand le jeton de rafraîchissement est refusé : l'utilisateur doit se reconnecter.
  final void Function() onSessionExpired;

  final AuthApi _authApi;

  /// Le client généré renseigne `extra['secure']` pour les routes qui exigent un jeton.
  bool _isProtected(RequestOptions options) =>
      (options.extra['secure'] as List?)?.isNotEmpty ?? false;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isProtected(options)) {
      final tokens = await storage.read();
      if (tokens != null) options.headers['Authorization'] = 'Bearer ${tokens.access}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 || !_isProtected(options)) return handler.next(err);

    final tokens = await storage.read();
    if (tokens == null) {
      onSessionExpired();
      return handler.next(err);
    }

    var access = tokens.access;
    // Si une autre requête a déjà renouvelé le jeton pendant que celle-ci attendait, on le réutilise
    if (options.headers['Authorization'] == 'Bearer $access') {
      try {
        final pair = (await _authApi.refresh(
          refreshRequest: RefreshRequest((b) => b..refreshToken = tokens.refresh),
        ))
            .data!;
        await storage.save(Tokens(pair.accessToken, pair.refreshToken));
        access = pair.accessToken;
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          await storage.clear();
          onSessionExpired();
        }
        return handler.next(err);
      }
    }

    options.headers['Authorization'] = 'Bearer $access';
    try {
      handler.resolve(await plainDio.fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
