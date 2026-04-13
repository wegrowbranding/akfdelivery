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
  final int accepted;
  final int pickedUp;
  final int outForDelivery;
  final int deliveredToday;
  final int rejected;

  Counts({
    required this.assigned,
    required this.accepted,
    required this.pickedUp,
    required this.outForDelivery,
    required this.deliveredToday,
    required this.rejected,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      assigned: json['assigned'] ?? 0,
      accepted: json['accepted'] ?? 0,
      pickedUp: json['picked_up'] ?? 0,
      outForDelivery: json['out_for_delivery'] ?? 0,
      deliveredToday: json['delivered_today'] ?? 0,
      rejected: json['rejected'] ?? 0,
    );
  }
}

class Listings {
  final List<OrderAssignment> assigned;
  final List<OrderAssignment> accepted;
  final List<OrderAssignment> pickedUp;
  final List<OrderAssignment> outForDelivery;

  Listings({
    required this.assigned,
    required this.accepted,
    required this.pickedUp,
    required this.outForDelivery,
  });

  factory Listings.fromJson(Map<String, dynamic> json) {
    return Listings(
      assigned:
          (json['assigned'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      accepted:
          (json['accepted'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      pickedUp:
          (json['picked_up'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
      outForDelivery:
          (json['out_for_delivery'] as List?)
              ?.map((o) => OrderAssignment.fromJson(o))
              .toList() ??
          [],
    );
  }
}
