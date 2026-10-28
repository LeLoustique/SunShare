import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../features/auth/auth_controller.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

/// Adresse de l'API, modifiable au lancement :
/// flutter run --dart-define=API_URL=http://10.0.2.2:8000   (émulateur Android)
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

Dio _newDio() => Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ));

final dioProvider = Provider<Dio>((ref) {
  return _newDio()
    ..interceptors.add(AuthInterceptor(
      plainDio: _newDio(),
      storage: ref.watch(tokenStorageProvider),
      onSessionExpired: () => ref.read(authControllerProvider.notifier).sessionExpired(),
    ));
});

/// Client généré (mobile/packages/sunshare_api) : getAuthApi(), getProfilApi(), getTechniqueApi()…
/// `interceptors: []` : on remplace les intercepteurs d'authentification génériques par le nôtre.
final apiProvider =
    Provider<SunshareApi>((ref) => SunshareApi(dio: ref.watch(dioProvider), interceptors: []));
