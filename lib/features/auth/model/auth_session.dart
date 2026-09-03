import 'app_user.dart';

/// What `/auth/register` and `/auth/login` return — a token plus the user
/// it belongs to (see `AuthResponse` in api.yaml).
class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final AppUser user;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthSession(
      token: data['token'] as String,
      user: AppUser.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
