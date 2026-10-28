import 'package:test/test.dart';
import 'package:sunshare_api/sunshare_api.dart';


/// tests for AuthApi
void main() {
  final instance = SunshareApi().getAuthApi();

  group(AuthApi, () {
    // Login
    //
    // Le champ `username` contient l'e-mail (convention OAuth2).
    //
    //Future<TokenPair> login(String username, String password, { String grantType, String scope, String clientId, String clientSecret }) async
    test('test login', () async {
      // TODO
    });

    // Refresh
    //
    //Future<TokenPair> refresh(RefreshRequest refreshRequest) async
    test('test refresh', () async {
      // TODO
    });

    // Register
    //
    //Future<UserOut> register(UserCreate userCreate) async
    test('test register', () async {
      // TODO
    });

  });
}
