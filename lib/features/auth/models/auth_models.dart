import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final DeliveryStaff? user;
  final Map<String, dynamic>? errors;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.errors,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data != null ? data['token'] : null,
      user: data != null && data['user'] != null
          ? DeliveryStaff.fromJson(data['user'])
          : null,
      errors: json['errors'] is Map<String, dynamic> ? json['errors'] : null,
    );
  }
}
