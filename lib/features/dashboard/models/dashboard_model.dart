import '../../orders/models/order_models.dart';

class DashboardData {
  final Counts counts;
  final Listings listings;
  final bool isAvailable;

  DashboardData({
    required this.counts,
    required this.listings,
    required this.isAvailable,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      counts: Counts.fromJson(json['counts'] ?? {}),
      listings: Listings.fromJson(json['listings'] ?? {}),
      isAvailable: json['is_available'] == 1 || json['is_available'] == true,
    );
  }
}

class Counts {
  final int assigned;
  final int outForDelivery;
  final int deliveredToday;

  Counts({
    required this.assigned,
    required this.outForDelivery,
    required this.deliveredToday,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      assigned: json['assigned'] ?? 0,
      outForDelivery: json['out_for_delivery'] ?? 0,
      deliveredToday: json['delivered_today'] ?? 0,
    );
  }
}

class Listings {
  final List<OrderAssignment> newOrders;
  final List<OrderAssignment> accepted;
  final List<OrderAssignment> outForDelivery;

  Listings({
    required this.newOrders,
    required this.accepted,
    required this.outForDelivery,
  });

  factory Listings.fromJson(Map<String, dynamic> json) {
    return Listings(
      newOrders: (json['new_orders'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      accepted: (json['accepted'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      outForDelivery: (json['out_for_delivery'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
    );
  }
}
