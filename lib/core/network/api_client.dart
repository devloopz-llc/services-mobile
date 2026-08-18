import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_endpoints.dart';
import 'api_error_handler.dart';
import 'api_failure.dart';
import 'api_result.dart';
import 'auth_token_store.dart';
import 'network_info.dart';

/// Single wrapper around [Dio] that every feature repository calls through.
///
/// It exists to kill the boilerplate of hand-rolling `try/catch` +
/// `DioException` handling on every API call: pick a method, pass a path
/// and an optional [decoder], and get back a typed [ApiResult] that is
/// either [ApiSuccess] or a normalized [ApiFailure] (see
/// [ApiErrorHandler]) — never a thrown exception.
///
/// ```dart
/// final result = await ApiClient.instance.get<List<Booking>>(
///   '/bookings',
///   decoder: (json) => (json['data'] as List).map(Booking.fromJson).toList(),
/// );
/// ```
class ApiClient {
  ApiClient._internal() : dio = _buildDio();

  static final ApiClient instance = ApiClient._internal();

  final Dio dio;
  final NetworkInfo _networkInfo = const NetworkInfo();

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        headers: const {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthTokenStore.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          compact: true,
        ),
      );
    }

    return dio;
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => dio.get(path, queryParameters: queryParameters, cancelToken: cancelToken),
      decoder: decoder,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => dio.post(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken),
      decoder: decoder,
    );
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => dio.put(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken),
      decoder: decoder,
    );
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => dio.patch(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken),
      decoder: decoder,
    );
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      () => dio.delete(path, data: data, queryParameters: queryParameters, cancelToken: cancelToken),
      decoder: decoder,
    );
  }

  Future<ApiResult<T>> _request<T>(
    Future<Response<dynamic>> Function() call, {
    T Function(dynamic json)? decoder,
  }) async {
    if (!await _networkInfo.isConnected) {
      return ApiResult.failure(
        const ApiFailure(
          message: 'No internet connection. Please check your network and try again.',
          type: ApiFailureType.noInternet,
        ),
      );
    }

    try {
      final response = await call();
      final body = response.data;
      final message = body is Map ? body['message'] as String? : null;
      final data = decoder != null ? decoder(body) : body as T;
      return ApiResult.success(data, message: message, statusCode: response.statusCode);
    } on DioException catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    } catch (error) {
      return ApiResult.failure(
        ApiFailure(message: 'Something went wrong. Please try again.', type: ApiFailureType.unknown),
      );
    }
  }
}
