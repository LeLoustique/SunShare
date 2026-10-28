import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Jetons de session : accès (15 min) et rafraîchissement (30 j).
class Tokens {
  const Tokens(this.access, this.refresh);

  final String access;
  final String refresh;
}

abstract interface class TokenStorage {
  Future<Tokens?> read();
  Future<void> save(Tokens tokens);
  Future<void> clear();
}

/// Stockage chiffré : Keychain (iOS), Keystore (Android), WebCrypto + localStorage (web, dev).
class SecureTokenStorage implements TokenStorage {
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  final _storage = const FlutterSecureStorage();

  @override
  Future<Tokens?> read() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) return null;
    return Tokens(access, refresh);
  }

  @override
  Future<void> save(Tokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.access);
    await _storage.write(key: _refreshKey, value: tokens.refresh);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => SecureTokenStorage());
