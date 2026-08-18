/// Central place for the API base URL and endpoint paths.
///
/// Swap [baseUrl] per environment (dev/staging/prod) once real
/// environment/flavor handling is added; hardcoded for now since no
/// backend is wired up yet.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}
