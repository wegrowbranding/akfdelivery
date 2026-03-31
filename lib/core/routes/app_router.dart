import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/orders/screens/assigned_orders_screen.dart';
import '../../features/orders/screens/order_details_screen.dart';
import '../../features/orders/screens/delivery_confirmation_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.root,
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isLoggingIn) {
        return AppRoutes.dashboard;
      }

      if (isAuthenticated && state.matchedLocation == AppRoutes.root) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.assignedOrders,
        builder: (context, state) => const AssignedOrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) {
          final orderId = state.extra as int?;
          return OrderDetailsScreen(orderId: orderId ?? 0);
        },
      ),
      GoRoute(
        path: AppRoutes.deliveryConfirmation,
        builder: (context, state) {
          final assignmentId = state.extra as int?;
          return DeliveryConfirmationScreen(assignmentId: assignmentId ?? 0);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
    ],
  );
}
