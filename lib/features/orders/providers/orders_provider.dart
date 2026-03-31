import 'package:flutter/material.dart';
import '../models/order_models.dart';
import '../services/orders_repository.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider({OrdersRepository? repository})
      : _repository = repository ?? OrdersRepository();

  final OrdersRepository _repository;
  OrderAssignment? _currentOrder;
  bool _isLoading = false;
  String? _error;

  OrderAssignment? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrderDetails(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _repository.getOrderDetails(orderId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> updateStatus(
    int assignmentId,
    String status, {
    String? remarks,
  }) async {
    try {
      final success = await _repository.updateOrderStatus(
        assignmentId: assignmentId,
        status: status,
        remarks: remarks,
      );
      if (success) {
        if (_currentOrder != null && _currentOrder!.id == assignmentId) {
          _currentOrder = OrderAssignment(
            id: _currentOrder!.id,
            orderId: _currentOrder!.orderId,
            deliveryStaffId: _currentOrder!.deliveryStaffId,
            assignedAt: _currentOrder!.assignedAt,
            status: status,
            order: _currentOrder!.order,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmDelivery(
    int assignmentId,
    String photoBase64, {
    String? remarks,
  }) async {
    try {
      final success = await _repository.confirmDeliveryWithPhoto(
        assignmentId: assignmentId,
        photoBase64: photoBase64,
        remarks: remarks,
      );
      if (success && _currentOrder != null && _currentOrder!.id == assignmentId) {
        _currentOrder = OrderAssignment(
          id: _currentOrder!.id,
          orderId: _currentOrder!.orderId,
          deliveryStaffId: _currentOrder!.deliveryStaffId,
          assignedAt: _currentOrder!.assignedAt,
          status: 'delivered',
          order: _currentOrder!.order,
        );
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  OrderHistoryResponse? _history;
  OrderHistoryResponse? get history => _history;

  Future<void> fetchOrderHistory({int page = 1}) async {
    if (page == 1) {
      _isLoading = true;
      _history = null;
      _error = null;
      notifyListeners();
    }

    try {
      final newHistory = await _repository.getOrderHistory(page: page);
      if (page == 1) {
        _history = newHistory;
      } else if (_history != null) {
        _history = OrderHistoryResponse(
          orders: [..._history!.orders, ...newHistory.orders],
          currentPage: newHistory.currentPage,
          lastPage: newHistory.lastPage,
          total: newHistory.total,
        );
      }
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
