/// In-memory holder for the current auth token.
///
/// [ApiClient] reads from this on every request. Swap the setter calls to
/// read/write `flutter_secure_storage` (or similar) once an auth feature
/// with persistence is added — nothing else needs to change.
class AuthTokenStore {
  const AuthTokenStore._();

  static String? _token;

  static String? get token => _token;

  static void save(String? token) => _token = token;

  static void clear() => _token = null;
}
