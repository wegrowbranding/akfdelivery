import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;
  DashboardData? _data;
  bool _isLoading = false;
  String? _error;

  DashboardData? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _repository.getDashboardData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> updateAvailability(bool isAvailable) async {
    try {
      final success = await _repository.updateAvailability(isAvailable);
      if (success) {
        if (_data != null) {
          _data = DashboardData(
            counts: _data!.counts,
            listings: _data!.listings,
            isAvailable: isAvailable,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}
