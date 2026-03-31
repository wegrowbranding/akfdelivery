import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/auth_models.dart';
import '../models/user_model.dart';
import '../services/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiService? apiService})
      : _authRepository = AuthRepository(apiService: apiService);

  DeliveryStaff? _user;
  String? _token;
  bool _isLoading = false;

  final AuthRepository _authRepository;

  DeliveryStaff? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    _token = await _authRepository.getToken();
    _user = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<AuthResponse> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authResponse = await _authRepository.login(email, password);

      if (authResponse.success && authResponse.token != null) {
        _token = authResponse.token;
        _user = authResponse.user;
      }

      _isLoading = false;
      notifyListeners();
      return authResponse;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _token = null;
      _user = null;
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void updateAvailability(bool isAvailable) {
    if (_user != null && _user!.deliveryDetails != null) {
      final newDetails = DeliveryDetails(
        id: _user!.deliveryDetails!.id,
        staffId: _user!.deliveryDetails!.staffId,
        vehicleType: _user!.deliveryDetails!.vehicleType,
        vehicleNumber: _user!.deliveryDetails!.vehicleNumber,
        isAvailable: isAvailable,
      );
      _user = DeliveryStaff(
        id: _user!.id,
        branchId: _user!.branchId,
        username: _user!.username,
        email: _user!.email,
        fullName: _user!.fullName,
        phone: _user!.phone,
        profileImage: _user!.profileImage,
        roleId: _user!.roleId,
        employeeId: _user!.employeeId,
        dateOfJoining: _user!.dateOfJoining,
        dateOfBirth: _user!.dateOfBirth,
        address: _user!.address,
        status: _user!.status,
        userType: _user!.userType,
        deliveryDetails: newDetails,
      );
      notifyListeners();
    }
  }
}
