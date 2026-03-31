import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../../../core/storage/preference_service.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();
  final ApiService _apiService;

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final authResponse = AuthResponse.fromJson(data);

      if (authResponse.success && authResponse.token != null) {
        await PreferenceService.saveToken(authResponse.token!);
        if (authResponse.user != null) {
          await PreferenceService.saveUserData(
            jsonEncode(authResponse.user!.toJson()),
          );
        }
      }

      return authResponse;
    } on Exception {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // await _apiService.post(ApiConstants.logout); // Implement if needed
      await PreferenceService.clearAuth();
    } on Exception {
      rethrow;
    }
  }

  Future<DeliveryStaff?> getCurrentUser() async {
    try {
      final userDataJson = await PreferenceService.getUserData();
      return userDataJson != null
          ? DeliveryStaff.fromJson(jsonDecode(userDataJson))
          : null;
    } on Exception {
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      return await PreferenceService.getToken();
    } on Exception {
      rethrow;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getToken();
      return token != null;
    } on Exception {
      return false;
    }
  }
}
