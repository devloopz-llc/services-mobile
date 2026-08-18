import 'api_failure.dart';

/// Result of any [ApiClient] call: either [ApiSuccess] or [ApiError].
///
/// Keeps controllers from ever touching Dio/`try-catch` directly — they
/// just pattern-match on the result via [when]/[fold].
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data, {String? message, int? statusCode}) = ApiSuccess<T>;

  const factory ApiResult.failure(ApiFailure failure) = ApiError<T>;

  bool get isSuccess => this is ApiSuccess<T>;

  bool get isFailure => this is ApiError<T>;

  /// Pattern-match both branches and produce a value of type [R].
  R when<R>({
    required R Function(T data, String? message) success,
    required R Function(ApiFailure failure) failure,
  }) {
    final self = this;
    if (self is ApiSuccess<T>) return success(self.data, self.message);
    if (self is ApiError<T>) return failure(self.failure);
    throw StateError('Unreachable ApiResult subtype');
  }

  /// Fire-and-forget variant of [when] for side effects only.
  void fold({
    void Function(T data, String? message)? onSuccess,
    void Function(ApiFailure failure)? onFailure,
  }) {
    final self = this;
    if (self is ApiSuccess<T> && onSuccess != null) onSuccess(self.data, self.message);
    if (self is ApiError<T> && onFailure != null) onFailure(self.failure);
  }

  /// Returns the success data, or `null` when this is a failure.
  T? get dataOrNull => this is ApiSuccess<T> ? (this as ApiSuccess<T>).data : null;
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, {this.message, this.statusCode});

  final T data;
  final String? message;
  final int? statusCode;
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.failure);

  final ApiFailure failure;
}
