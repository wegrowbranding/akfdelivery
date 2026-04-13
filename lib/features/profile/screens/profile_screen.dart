import 'package:akfdelivery/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    // Design Tokens moved inside build to ensure safe initialization and access
    const Color primaryColor = Color(0xFFE91E63);
    const Color secondaryColor = Color(0xFFF06292);
    const Color backgroundColor = Color(0xFFF9F6F2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Decorative Element
          Positioned(
            top: -50,
            left: -50,
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
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildProfileCard(user, primaryColor),
                        const SizedBox(height: 32),

                        _buildSectionLabel("PROFESSIONAL DETAILS"),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(
                            'EMAIL ADDRESS',
                            user?.email ?? 'partner@flora.com',
                          ),
                          const Divider(height: 32, thickness: 0.5),
                          _buildInfoRow(
                            'CONTACT NUMBER',
                            user?.phone ?? '+1 234 567 890',
                          ),
                        ]),

                        const SizedBox(height: 32),
                        _buildSectionLabel("VEHICLE SPECIFICATIONS"),
                        const SizedBox(height: 12),
                        _buildInfoCard([
                          _buildInfoRow(
                            'VEHICLE TYPE',
                            user?.deliveryDetails?.vehicleType.toUpperCase() ??
                                'COURIER',
                          ),
                          const Divider(height: 32, thickness: 0.5),
                          _buildInfoRow(
                            'PLATE NUMBER',
                            user?.deliveryDetails?.vehicleNumber ?? 'FLR-2024',
                          ),
                        ]),

                        const SizedBox(height: 48),
                        _buildLogoutButton(
                          context,
                          authProvider,
                          primaryColor,
                          secondaryColor,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "AK FLOWERS DELIVERY",
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Account Profile',
                style: TextStyle(
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

  Widget _buildProfileCard(dynamic user, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFF9F6F2),
              // Placeholder Unsplash image for a professional delivery partner look
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200&auto=format&fit=crop",
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user?.fullName ?? 'Delivery Partner',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user?.userType.toUpperCase() ?? 'DELIVERY STAFF',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
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
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.black26,
            letterSpacing: 1,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AuthProvider authProvider,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return GestureDetector(
      onTap: () {
        authProvider.logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            SizedBox(width: 12),
            Text(
              'LOGOUT',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
