/// Mirrors the backend's `User` schema (see api.yaml). `super_admin` and
/// `staff` exist server-side but can never sign in through this API, so
/// they're deliberately not modeled here.
enum UserRole {
  customer,
  technician;

  static UserRole fromApiValue(String value) => switch (value) {
        'technician' => UserRole.technician,
        _ => UserRole.customer,
      };
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
  });

  final int id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: UserRole.fromApiValue(json['role'] as String),
    );
  }
}
