import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Design Tokens consistent with the FLORA Pro Look
  final Color primaryColor = const Color(0xFFE91E63);
  final Color secondaryColor = const Color(0xFFF06292);
  final Color backgroundColor = const Color(0xFFF9F6F2);
  final Color textColor = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

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
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () => dashboardProvider.fetchDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user?.fullName),
                    const SizedBox(height: 32),

                    // 1. Availability/Duty Toggle Card
                    _buildAvailabilityCard(dashboardProvider, authProvider),

                    const SizedBox(height: 40),

                    // 2. Metrics Section
                    _buildSectionLabel('DAILY PERFORMANCE'),
                    const SizedBox(height: 16),
                    _buildMetricsGrid(dashboardProvider),

                    const SizedBox(height: 40),

                    // 3. Quick Actions
                    _buildSectionLabel('OPERATIONS'),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      title: 'Assigned Bouquets',
                      subtitle: 'Current delivery queue',
                      icon: Icons.delivery_dining_rounded,
                      onTap: () => context.push(AppRoutes.assignedOrders),
                      badgeCount: dashboardProvider.data?.counts.assigned ?? 0,
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      title: 'Delivery History',
                      subtitle: 'Review completed drops',
                      icon: Icons.history_rounded,
                      onTap: () => context.push(AppRoutes.orderHistory),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String? name) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AK FLOWERS DELIVERY",
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name ?? 'Partner',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Serif',
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: primaryColor,
                size: 22,
              ),
            ),
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

  Widget _buildAvailabilityCard(
    DashboardProvider dashboardProvider,
    AuthProvider authProvider,
  ) {
    final isAvailable = dashboardProvider.data?.isAvailable ?? false;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isAvailable
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.03),
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
              color: isAvailable
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAvailable
                  ? Icons.bolt_rounded
                  : Icons.power_settings_new_rounded,
              color: isAvailable ? Colors.green : Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable ? 'ACTIVE DUTY' : 'OFF DUTY',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                    color: isAvailable
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isAvailable
                      ? 'Ready for new bouquets'
                      : 'Take a rest, partner',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: isAvailable,
              // ignore: deprecated_member_use
              activeColor: Colors.green,
              onChanged: (value) async {
                final success = await dashboardProvider.updateAvailability(
                  value,
                );
                if (success) {
                  authProvider.updateAvailability(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(DashboardProvider provider) {
    final counts = provider.data?.counts;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildMetricCard(
          'ASSIGNED',
          counts?.assigned.toString() ?? '0',
          Colors.blue.shade400,
        ),
        _buildMetricCard(
          'ACCEPTED',
          counts?.accepted.toString() ?? '0',
          Colors.indigo.shade400,
        ),
        _buildMetricCard(
          'PICKED UP',
          counts?.pickedUp.toString() ?? '0',
          Colors.teal.shade400,
        ),
        _buildMetricCard(
          'OUT FOR DELIVERY',
          counts?.outForDelivery.toString() ?? '0',
          Colors.orange.shade400,
        ),
        _buildMetricCard(
          'DELIVERED TODAY',
          counts?.deliveredToday.toString() ?? '0',
          Colors.green.shade400,
        ),
        _buildMetricCard(
          'REJECTED',
          counts?.rejected.toString() ?? '0',
          primaryColor.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'Serif', // Matching the Pro look numbers
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withValues(alpha: 0.35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ],
        ),
      ),
    );
  }
}
