import 'package:dio/dio.dart';
import 'api_failure.dart';

/// Single source of truth for turning *any* Dio failure into a clean,
/// user-facing [ApiFailure] — covers connection-level errors (timeout,
/// no internet, cancelled) and every HTTP status code, and is defensive
/// about response body shape (String, Map with `message`/`error`/`errors`/
/// `detail`, list of errors, HTML error pages, or empty body).
class ApiErrorHandler {
  const ApiErrorHandler._();

  static ApiFailure handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiFailure(
          message: 'The request timed out. Please check your connection and try again.',
          type: ApiFailureType.timeout,
        );
      case DioExceptionType.connectionError:
        return const ApiFailure(
          message: 'No internet connection. Please check your network and try again.',
          type: ApiFailureType.noInternet,
        );
      case DioExceptionType.cancel:
        return const ApiFailure(
          message: 'Request was cancelled.',
          type: ApiFailureType.cancel,
        );
      case DioExceptionType.badCertificate:
        return const ApiFailure(
          message: 'Could not establish a secure connection.',
          type: ApiFailureType.unknown,
        );
      case DioExceptionType.badResponse:
        return _fromStatusCode(error);
      case DioExceptionType.unknown:
        return ApiFailure(
          message: _isLikelyNoInternet(error)
              ? 'No internet connection. Please check your network and try again.'
              : 'Something went wrong. Please try again.',
          type: _isLikelyNoInternet(error) ? ApiFailureType.noInternet : ApiFailureType.unknown,
        );
    }
  }

  static bool _isLikelyNoInternet(DioException error) {
    final message = error.message?.toLowerCase() ?? '';
    return message.contains('socketexception') ||
        message.contains('network is unreachable') ||
        message.contains('failed host lookup');
  }

  static ApiFailure _fromStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;
    final extractedMessage = _extractMessage(error.response?.data);
    final fieldErrors = _extractFieldErrors(error.response?.data);

    switch (statusCode) {
      case 400:
        return ApiFailure(
          message: extractedMessage ?? 'Invalid request. Please check your input.',
          type: ApiFailureType.badRequest,
          statusCode: statusCode,
          fieldErrors: fieldErrors,
        );
      case 401:
        return ApiFailure(
          message: extractedMessage ?? 'Your session has expired. Please log in again.',
          type: ApiFailureType.unauthorized,
          statusCode: statusCode,
        );
      case 403:
        return ApiFailure(
          message: extractedMessage ?? "You don't have permission to do that.",
          type: ApiFailureType.forbidden,
          statusCode: statusCode,
        );
      case 404:
        return ApiFailure(
          message: extractedMessage ?? 'The requested resource was not found.',
          type: ApiFailureType.notFound,
          statusCode: statusCode,
        );
      case 409:
        return ApiFailure(
          message: extractedMessage ?? 'This conflicts with existing data.',
          type: ApiFailureType.conflict,
          statusCode: statusCode,
        );
      case 422:
        return ApiFailure(
          message: extractedMessage ?? 'Some fields need your attention.',
          type: ApiFailureType.validation,
          statusCode: statusCode,
          fieldErrors: fieldErrors,
        );
      case 429:
        return ApiFailure(
          message: extractedMessage ?? 'Too many requests. Please slow down and try again.',
          type: ApiFailureType.tooManyRequests,
          statusCode: statusCode,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiFailure(
            message: extractedMessage ?? "Something went wrong on our end. Please try again shortly.",
            type: ApiFailureType.server,
            statusCode: statusCode,
          );
        }
        return ApiFailure(
          message: extractedMessage ?? 'Something went wrong${statusCode != null ? ' (code $statusCode)' : ''}.',
          type: ApiFailureType.unknown,
          statusCode: statusCode,
        );
    }
  }

  /// Digs through common backend error-response shapes to find a
  /// human-readable message, regardless of API convention.
  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      // Don't surface raw HTML error pages (e.g. gateway/proxy errors).
      if (trimmed.startsWith('<')) return null;
      return trimmed;
    }

    if (data is Map) {
      for (final key in ['message', 'error', 'error_description', 'detail', 'title']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) return value.trim();
      }

      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) return firstValue.first.toString();
        if (firstValue is String && firstValue.isNotEmpty) return firstValue;
      }
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String) return first;
        if (first is Map) return _extractMessage(first);
      }
    }

    if (data is List && data.isNotEmpty) {
      return data.first.toString();
    }

    return null;
  }

  static Map<String, dynamic>? _extractFieldErrors(dynamic data) {
    if (data is Map && data['errors'] is Map) {
      return Map<String, dynamic>.from(data['errors'] as Map);
    }
    return null;
  }
}
