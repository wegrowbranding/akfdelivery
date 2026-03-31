import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../models/order_models.dart';

class OrdersRepository {
  OrdersRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();
  final ApiService _apiService;

  Future<OrderAssignment> getOrderDetails(int orderId) async {
    try {
      final response = await _apiService.get(ApiConstants.orderDetails(orderId));
      final data = response.data['data'] as Map<String, dynamic>;
      final assignment = OrderAssignment.fromJson(data['assignment'] ?? {});
      final order = DeliveryOrder.fromJson(data['order'] ?? {});
      return OrderAssignment(
        id: assignment.id,
        orderId: assignment.orderId,
        deliveryStaffId: assignment.deliveryStaffId,
        assignedAt: assignment.assignedAt,
        status: assignment.status,
        order: order,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrderStatus({
    required int assignmentId,
    required String status,
    String? remarks,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.updateOrderStatus,
        data: {
          'assignment_id': assignmentId,
          'status': status,
          'remarks': remarks ?? 'Order status updated to $status',
        },
      );
      return response.data['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmDeliveryWithPhoto({
    required int assignmentId,
    required String photoBase64,
    String? remarks,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.confirmDeliveryPhoto,
        data: {
          'assignment_id': assignmentId,
          'photo_base64': photoBase64,
          'remarks': remarks ?? 'Delivery confirmed with photo',
        },
      );
      return response.data['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateTracking({
    required int assignmentId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.updateTracking,
        data: {
          'assignment_id': assignmentId,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        },
      );
      return response.data['success'] ?? false;
    } catch (e) {
      // Background tracking – maybe we just log and move on if it fails
      return false;
    }
  }

  Future<OrderHistoryResponse> getOrderHistory({int page = 1}) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.orderHistory}?page=$page',
      );
      return OrderHistoryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
