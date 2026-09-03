import 'dart:io' show Platform;

/// Central place for the API base URL and endpoint paths.
///
/// Points at the local `php artisan serve` backend for now — swap for a
/// real per-environment (dev/staging/prod) flavor setup before shipping.
/// Android's emulator can't reach the host's `127.0.0.1` directly (it
/// needs the special `10.0.2.2` alias); iOS's simulator shares the host
/// network stack, so `127.0.0.1` works as-is.
class ApiEndpoints {
  const ApiEndpoints._();

  static String get baseUrl {
    final host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
    return 'http://$host:8000/api/v1';
  }

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
