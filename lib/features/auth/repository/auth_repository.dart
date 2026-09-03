import 'dart:io' show Platform;

import '../../../core/network/api_client.dart';
import '../../../core/network/api_result.dart';
import '../model/app_user.dart';
import '../model/auth_session.dart';

/// Thin wrapper over `ApiClient` for the `/auth/*` endpoints (api.yaml).
/// Pure data access — no token persistence or app-state side effects here,
/// that's [AuthService]'s job.
class AuthRepository {
  static String get _deviceName => Platform.isIOS ? 'iOS App' : 'Android App';

  Future<ApiResult<AuthSession>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) {
    return ApiClient.instance.post<AuthSession>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'device_name': _deviceName,
      },
      decoder: (json) => AuthSession.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<AuthSession>> login({required String email, required String password}) {
    return ApiClient.instance.post<AuthSession>(
      '/auth/login',
      data: {'email': email, 'password': password, 'device_name': _deviceName},
      decoder: (json) => AuthSession.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<void>> logout() {
    return ApiClient.instance.post<void>('/auth/logout');
  }

  Future<ApiResult<AppUser>> me() {
    return ApiClient.instance.get<AppUser>(
      '/auth/me',
      decoder: (json) => AppUser.fromJson((json as Map<String, dynamic>)['data'] as Map<String, dynamic>),
    );
  }

  Future<ApiResult<void>> forgotPassword(String email) {
    return ApiClient.instance.post<void>('/auth/forgot-password', data: {'email': email});
  }
}
