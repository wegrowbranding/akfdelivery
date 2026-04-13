import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../orders/models/order_models.dart';
import '../../orders/providers/orders_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  // Design Tokens consistent with the FLORA Pro Look
  final Color primaryColor = const Color(0xFFE91E63);
  final Color backgroundColor = const Color(0xFFF9F6F2);
  final Color textColor = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchOrderHistory(page: 1);
    });

    _scrollController.addListener(() {
      final provider = context.read<OrdersProvider>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          provider.history != null &&
          provider.history!.currentPage < provider.history!.lastPage) {
        provider.fetchOrderHistory(page: provider.history!.currentPage + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final history = provider.history;

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
                Expanded(
                  child: provider.isLoading && history == null
                      ? const Center(child: CircularProgressIndicator())
                      : provider.error != null && history == null
                      ? Center(child: Text(provider.error!))
                      : _buildHistoryList(history?.orders ?? []),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 20),
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
                'Order History',
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

  Widget _buildHistoryList(List<OrderAssignment> orders) {
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
                Icons.history_rounded,
                size: 48,
                color: primaryColor.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No orders yet',
              style: TextStyle(
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

    return RefreshIndicator(
      onRefresh: () =>
          context.read<OrdersProvider>().fetchOrderHistory(page: 1),
      color: primaryColor,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        itemCount:
            orders.length + (context.read<OrdersProvider>().isLoading ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          if (index < orders.length) {
            return _buildOrderCard(orders[index]);
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderAssignment assignment) {
    final order = assignment.order;
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
                  assignment.status.replaceAll('_', ' ').toUpperCase(),
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
                    Text(
                      _formatDate(assignment.assignedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.push(AppRoutes.orderDetails, extra: order?.id),
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'VIEW DETAILS',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return Colors.blue.shade600;
      case 'accepted':
        return Colors.indigo.shade600;
      case 'picked_up':
        return Colors.teal.shade600;
      case 'out_for_delivery':
        return Colors.orange.shade600;
      case 'delivered':
        return Colors.green.shade600;
      case 'rejected':
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day} ${_getMonth(date.month)} ${date.year}, ${_formatTime(date)}";
    } catch (e) {
      return dateStr;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }
}
