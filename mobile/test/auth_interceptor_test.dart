import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sunshare/core/auth_interceptor.dart';
import 'package:sunshare/core/token_storage.dart';
import 'package:sunshare_api/sunshare_api.dart';

import 'helpers.dart';

/// Serveur HTTP simulé : [handle] reçoit la requête et renvoie (statut, corps JSON).
class FakeServer implements HttpClientAdapter {
  FakeServer(this.handle);

  final (int, Object) Function(RequestOptions request) handle;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = handle(options);
    return ResponseBody.fromString(jsonEncode(body), status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

const meJson = {
  'id': '0b4c8a1e-0000-4000-8000-000000000001',
  'email': 'camille@exemple.fr',
  'first_name': 'Camille',
  'last_name': 'Martin',
  'role': 'producer',
  'created_at': '2026-10-28T09:00:00Z',
};

/// Client branché comme dans l'app (voir core/api.dart), mais sur le serveur simulé.
({SunshareApi api, MemoryTokenStorage storage, List<String> events}) setUp(
  FakeServer server, {
  Tokens? tokens,
}) {
  Dio newDio() => Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = server;
  final storage = MemoryTokenStorage(tokens);
  final events = <String>[];
  final dio = newDio()
    ..interceptors.add(AuthInterceptor(
      plainDio: newDio(),
      storage: storage,
      onSessionExpired: () => events.add('session expirée'),
    ));
  return (api: SunshareApi(dio: dio, interceptors: []), storage: storage, events: events);
}

void main() {
  test('ajoute le jeton aux routes protégées uniquement', () async {
    final server = FakeServer((r) => r.path.endsWith('/me') ? (200, meJson) : (200, {'status': 'ok', 'extensions': {}}));
    final client = setUp(server, tokens: const Tokens('acces-1', 'refresh-1'));

    await client.api.getProfilApi().readMe();
    await client.api.getTechniqueApi().health();

    expect(server.requests[0].headers['Authorization'], 'Bearer acces-1');
    expect(server.requests[1].headers.containsKey('Authorization'), isFalse);
  });

  test('jeton expiré : rafraîchit, enregistre les nouveaux jetons et rejoue la requête', () async {
    final server = FakeServer((r) {
      if (r.path.endsWith('/auth/refresh')) {
        expect((r.data as Map)['refresh_token'], 'refresh-1');
        return (200, {'access_token': 'acces-2', 'refresh_token': 'refresh-2', 'token_type': 'bearer'});
      }
      return r.headers['Authorization'] == 'Bearer acces-2'
          ? (200, meJson)
          : (401, {'detail': 'Jeton invalide ou expiré'});
    });
    final client = setUp(server, tokens: const Tokens('acces-1', 'refresh-1'));

    final me = (await client.api.getProfilApi().readMe()).data!;

    expect(me.firstName, 'Camille');
    expect(server.requests.map((r) => r.path), [
      '/api/v1/me',
      '/api/v1/auth/refresh',
      '/api/v1/me',
    ]);
    expect(client.storage.tokens!.access, 'acces-2');
    expect(client.storage.tokens!.refresh, 'refresh-2');
    expect(client.events, isEmpty);
  });

  test('deux requêtes en 401 simultanées : un seul rafraîchissement', () async {
    var refreshCount = 0;
    final server = FakeServer((r) {
      if (r.path.endsWith('/auth/refresh')) {
        refreshCount++;
        return (200, {'access_token': 'acces-2', 'refresh_token': 'refresh-2'});
      }
      return r.headers['Authorization'] == 'Bearer acces-2'
          ? (200, meJson)
          : (401, {'detail': 'Jeton invalide ou expiré'});
    });
    final client = setUp(server, tokens: const Tokens('acces-1', 'refresh-1'));

    await Future.wait([client.api.getProfilApi().readMe(), client.api.getProfilApi().readMe()]);

    expect(refreshCount, 1);
  });

  test('rafraîchissement refusé : efface les jetons et signale la fin de session', () async {
    final server = FakeServer((_) => (401, {'detail': 'Jeton invalide ou expiré'}));
    final client = setUp(server, tokens: const Tokens('acces-1', 'refresh-1'));

    await expectLater(
      client.api.getProfilApi().readMe(),
      throwsA(isA<DioException>().having((e) => e.response?.statusCode, 'statut', 401)),
    );
    expect(client.storage.tokens, isNull);
    expect(client.events, ['session expirée']);
  });

  test("une 401 sur la connexion (mauvais mot de passe) ne déclenche pas de rafraîchissement", () async {
    final server = FakeServer((_) => (401, {'detail': 'E-mail ou mot de passe incorrect'}));
    final client = setUp(server);

    await expectLater(
      client.api.getAuthApi().login(username: 'camille@exemple.fr', password: 'faux'),
      throwsA(isA<DioException>()),
    );
    expect(server.requests, hasLength(1));
    expect(client.events, isEmpty);
  });
}
