import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  DashboardRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();
  final ApiService _apiService;

  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _apiService.get(ApiConstants.dashboard);
      final data = response.data['data'] as Map<String, dynamic>;
      return DashboardData.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateAvailability(bool isAvailable) async {
    try {
      final response = await _apiService.post(
        ApiConstants.updateAvailability,
        data: {'is_available': isAvailable},
      );
      return response.data['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
