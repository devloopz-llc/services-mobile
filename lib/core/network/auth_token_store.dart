import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the current Sanctum token — Keychain/EncryptedSharedPreferences
/// via `flutter_secure_storage`, never plain prefs (see conventions.md
/// §Authentication: "Store it in secure storage").
///
/// [ApiClient]'s request interceptor reads [token] synchronously on every
/// call, so a copy is kept in memory alongside the persisted value; call
/// [load] once at startup (before the first authenticated request) to
/// populate it from disk.
class AuthTokenStore {
  const AuthTokenStore._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'auth_token';

  static String? _cachedToken;

  static String? get token => _cachedToken;

  static Future<void> load() async {
    _cachedToken = await _storage.read(key: _key);
  }

  static Future<void> save(String? token) async {
    _cachedToken = token;
    if (token == null) {
      await _storage.delete(key: _key);
    } else {
      await _storage.write(key: _key, value: token);
    }
  }

  static Future<void> clear() async {
    _cachedToken = null;
    await _storage.delete(key: _key);
  }
}
