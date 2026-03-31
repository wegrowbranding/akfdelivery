class OrderAssignment {
  final int id;
  final int orderId;
  final int deliveryStaffId;
  final String assignedAt;
  final String status;
  final DeliveryOrder? order;

  OrderAssignment({
    required this.id,
    required this.orderId,
    required this.deliveryStaffId,
    required this.assignedAt,
    required this.status,
    this.order,
  });

  factory OrderAssignment.fromJson(Map<String, dynamic> json) {
    return OrderAssignment(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      deliveryStaffId: json['delivery_staff_id'] ?? 0,
      assignedAt: json['assigned_at'] ?? '',
      status: json['status'] ?? '',
      order: json['order'] != null ? DeliveryOrder.fromJson(json['order']) : null,
    );
  }
}

class DeliveryOrder {
  final int id;
  final String orderNumber;
  final String totalAmount;
  final String finalAmount;
  final String paymentStatus;
  final String orderStatus;
  final String paymentMethod;
  final String placedAt;
  final List<DeliveryOrderItem> items;
  final Customer? customer;
  final Address? address;

  DeliveryOrder({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.finalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentMethod,
    required this.placedAt,
    required this.items,
    this.customer,
    this.address,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',
      finalAmount: json['final_amount']?.toString() ?? '0',
      paymentStatus: json['payment_status'] ?? '',
      orderStatus: json['order_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      placedAt: json['placed_at'] ?? '',
      items: (json['items'] as List?)
              ?.map((i) => DeliveryOrderItem.fromJson(i))
              .toList() ??
          [],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      address: json['customer_address'] != null
          ? Address.fromJson(json['customer_address'])
          : null,
    );
  }
}

class DeliveryOrderItem {
  final int id;
  final int productId;
  final int quantity;
  final String price;
  final String totalPrice;

  DeliveryOrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItem(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toString() ?? '0',
      totalPrice: json['total_price']?.toString() ?? '0',
    );
  }
}

class Customer {
  final int id;
  final String fullName;
  final String email;
  final String phone;

  Customer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Address {
  final int id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}

class OrderHistoryResponse {
  final List<OrderAssignment> orders;
  final int currentPage;
  final int lastPage;
  final int total;

  OrderHistoryResponse({
    required this.orders,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return OrderHistoryResponse(
      orders: (data['data'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      currentPage: data['current_page'] ?? 1,
      lastPage: data['last_page'] ?? 1,
      total: data['total'] ?? 0,
    );
  }
}
