import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../dashboard/providers/dashboard_provider.dart';
import '../../orders/models/order_models.dart';
import '../../orders/providers/orders_provider.dart';

class AssignedOrdersScreen extends StatefulWidget {
  const AssignedOrdersScreen({super.key});

  @override
  State<AssignedOrdersScreen> createState() => _AssignedOrdersScreenState();
}

class _AssignedOrdersScreenState extends State<AssignedOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Design Tokens consistent with the FLORA Pro Look
  final Color primaryColor = const Color(0xFFE91E63);
  final Color secondaryColor = const Color(0xFFF06292);
  final Color backgroundColor = const Color(0xFFF9F6F2);
  final Color textColor = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final listings = dashboardProvider.data?.listings;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Decorative Element
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildCustomTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(
                        listings?.assigned ?? [],
                        'New Requests',
                      ),
                      _buildOrderList(
                        listings?.accepted ?? [],
                        'Accepted Assignments',
                      ),
                      _buildOrderList(
                        listings?.pickedUp ?? [],
                        'Orders to be Transited',
                      ),
                      _buildOrderList(
                        listings?.outForDelivery ?? [],
                        'In-Transit Bouquets',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              const Text(
                'Assigned Tasks',
                style: TextStyle(
                  fontSize: 20,
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

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primaryColor,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black38,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(text: 'NEW'),
            Tab(text: 'ACCEPTED'),
            Tab(text: 'PICKED UP'),
            Tab(text: 'TRANSIT'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderAssignment> orders, String emptyTitle) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 48,
                color: primaryColor.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $emptyTitle',
              style: const TextStyle(
                fontFamily: 'Serif',
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(OrderAssignment assignment) {
    final order = assignment.order;
    // Premium placeholder image for a boutique feel
    const String thumbUrl =
        "https://images.unsplash.com/photo-1526047932273-341f2a7631f9?q=80&w=200&auto=format&fit=crop";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "BOUQUET",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    order?.orderNumber ?? 'ORD-XXXXXX',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    assignment.status,
                  ).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  assignment.status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(assignment.status),
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: NetworkImage(thumbUrl),
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
                      order?.customer?.fullName ?? 'Anonymous Customer',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${order?.address?.addressLine1 ?? ''}, ${order?.address?.city ?? ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '₹${order?.finalAmount ?? '0'}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  fontFamily: 'Serif',
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionSection(assignment),
        ],
      ),
    );
  }

  Widget _buildActionSection(OrderAssignment assignment) {
    if (assignment.status == 'assigned') {
      return Row(
        children: [
          Expanded(child: _buildSecondaryBtn('REJECT', Colors.red, () async {
            final ok = await context.read<OrdersProvider>().updateStatus(
              assignment.id,
              'rejected',
            );
            if (ok) context.read<DashboardProvider>().fetchDashboardData();
          })),
          const SizedBox(width: 16),
          Expanded(child: _buildPrimaryBtn('ACCEPT', () async {
            final ok = await context.read<OrdersProvider>().updateStatus(
              assignment.id,
              'accepted',
            );
            if (ok) context.read<DashboardProvider>().fetchDashboardData();
          })),
        ],
      );
    }

    String btnText = 'VIEW DETAILS';
    String? nextStatus;

    if (assignment.status == 'accepted') {
      btnText = 'PICK UP BOUQUET';
      nextStatus = 'picked_up';
    } else if (assignment.status == 'picked_up') {
      btnText = 'START DELIVERY';
      nextStatus = 'out_for_delivery';
    }

    return _buildPrimaryBtn(btnText, () async {
      if (nextStatus != null) {
        final ok = await context.read<OrdersProvider>().updateStatus(
          assignment.id,
          nextStatus,
        );
        if (ok) {
          context.read<DashboardProvider>().fetchDashboardData();
          if (nextStatus == 'out_for_delivery') {
             context.push(AppRoutes.orderDetails, extra: assignment.order?.id);
          }
        }
      } else {
        context.push(AppRoutes.orderDetails, extra: assignment.order?.id);
      }
    });
  }

  Widget _buildPrimaryBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryBtn(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Colors.blue.shade400;
      case 'accepted':
        return Colors.indigo.shade400;
      case 'picked_up':
        return Colors.teal.shade400;
      case 'out_for_delivery':
        return Colors.orange.shade400;
      case 'delivered':
        return Colors.green.shade400;
      case 'rejected':
        return Colors.red.shade400;
      default:
        return Colors.black26;
    }
  }
}
