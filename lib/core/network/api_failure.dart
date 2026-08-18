/// Classifies *why* an API call failed so UI/controllers can react
/// differently (e.g. force logout on [unauthorized], highlight fields on
/// [validation]) without string-matching messages.
enum ApiFailureType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  tooManyRequests,
  server,
  timeout,
  noInternet,
  cancel,
  unknown,
}

/// Normalized failure produced by [ApiErrorHandler] for *any* Dio error,
/// regardless of the backend's error response shape.
class ApiFailure {
  const ApiFailure({
    required this.message,
    required this.type,
    this.statusCode,
    this.fieldErrors,
  });

  final String message;
  final ApiFailureType type;
  final int? statusCode;

  /// Per-field validation errors when the backend returns something like
  /// `{"errors": {"email": ["is required"]}}` (422 responses).
  final Map<String, dynamic>? fieldErrors;

  @override
  String toString() => 'ApiFailure(type: $type, statusCode: $statusCode, message: $message)';
}
