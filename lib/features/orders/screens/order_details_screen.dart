import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../models/order_models.dart';
import '../providers/orders_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Design Tokens consistent with the FLORA Pro Look
  final Color primaryColor = const Color(0xFFE91E63);
  final Color secondaryColor = const Color(0xFFF06292);
  final Color backgroundColor = const Color(0xFFF9F6F2);
  final Color textColor = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrdersProvider>();
    final assignment = orderProvider.currentOrder;
    final order = assignment?.order;

    if (orderProvider.isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (assignment == null || order == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Decorative Element
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, order.orderNumber),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Status Header
                        _buildStatusHeader(assignment.status),
                        const SizedBox(height: 32),

                        // Customer Info
                        _buildSectionLabel('RECIPIENT INFORMATION'),
                        const SizedBox(height: 12),
                        _buildCustomerCard(order),

                        const SizedBox(height: 32),
                        // Items
                        _buildSectionLabel('BOUQUET COMPOSITION'),
                        const SizedBox(height: 12),
                        _buildItemsList(order.items),

                        const SizedBox(height: 32),
                        // Price info
                        _buildSectionLabel('PAYMENT SUMMARY'),
                        const SizedBox(height: 12),
                        _buildPriceCard(order),
                        const SizedBox(height: 120), // Action button space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildActionBtn(context, assignment),
    );
  }

  Widget _buildHeader(BuildContext context, String orderNo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "AK FLOWERS DELIVERY",
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Order #$orderNo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Serif',
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.w800,
        color: Colors.black38,
      ),
    );
  }

  Widget _buildStatusHeader(String status) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT PROGRESS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status.toUpperCase().replaceAll('_', ' '),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(DeliveryOrder order) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customer?.fullName ?? 'Anonymous Customer',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      order.customer?.phone ?? 'No contact provided',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    launchUrl(Uri.parse('tel:${order.customer?.phone}')),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, thickness: 0.5),
          ),
          const Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              SizedBox(width: 10),
              Text(
                'DESTINATION',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  color: Colors.black38,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              '${order.address?.addressLine1 ?? ''}\n${order.address?.addressLine2 ?? ''}\n${order.address?.city ?? ''}, ${order.address?.pincode ?? ''}',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withValues(alpha: 0.7),
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<DeliveryOrderItem> items) {
    return Column(
      children: items.map((item) {
        // Placeholder flower image for a premium look
        const String flowerUrl =
            "https://images.unsplash.com/photo-1526047932273-341f2a7631f9?q=80&w=200&auto=format&fit=crop";

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(flowerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collection Item',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'ID: ${item.productId}',
                      style: const TextStyle(
                        color: Colors.black26,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'x${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceCard(DeliveryOrder order) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PAYMENT TYPE',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                order.paymentMethod.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'COLLECTION TOTAL',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '₹${order.finalAmount}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: primaryColor,
                  fontFamily: 'Serif',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, OrderAssignment assignment) {
    String btnText = 'ACCEPT ORDER';
    String nextStatus = 'accepted';

    switch (assignment.status) {
      case 'assigned':
        btnText = 'ACCEPT ORDER';
        nextStatus = 'accepted';
        break;
      case 'accepted':
        btnText = 'PICK UP BOUQUET';
        nextStatus = 'picked_up';
        break;
      case 'picked_up':
        btnText = 'START DELIVERY';
        nextStatus = 'out_for_delivery';
        break;
      case 'out_for_delivery':
        btnText = 'COMPLETE DELIVERY';
        nextStatus = 'delivered';
        break;
      case 'delivered':
      case 'rejected':
      case 'cancelled':
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          if (nextStatus == 'delivered') {
            context.push(AppRoutes.deliveryConfirmation, extra: assignment.id);
          } else {
            final success = await context.read<OrdersProvider>().updateStatus(
              assignment.id,
              nextStatus,
            );
            if (success) {
              context.read<DashboardProvider>().fetchDashboardData();
            }
          }
        },
        child: Container(
          height: 65,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              btnText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
