import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../providers/orders_provider.dart';
import '../../dashboard/providers/dashboard_provider.dart';

class DeliveryConfirmationScreen extends StatefulWidget {
  const DeliveryConfirmationScreen({super.key, required this.assignmentId});

  final int assignmentId;

  @override
  State<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState
    extends State<DeliveryConfirmationScreen> {
  XFile? _image;
  final _remarksController = TextEditingController();
  bool _isUploading = false;

  // Design Tokens consistent with the FLORA Pro Look
  final Color primaryColor = const Color(0xFFE91E63);
  final Color secondaryColor = const Color(0xFFF06292);
  final Color backgroundColor = const Color(0xFFF9F6F2);
  final Color textColor = const Color(0xFF1A1A1A);

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      _image = image;
    });
  }

  Future<void> _confirmDelivery() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture a photo of the arrangement'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final bytes = await File(_image!.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final success = await context.read<OrdersProvider>().confirmDelivery(
        widget.assignmentId,
        base64Image,
        remarks: _remarksController.text,
      );

      if (success && mounted) {
        context.read<DashboardProvider>().fetchDashboardData();
        context.go(AppRoutes.dashboard);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Delivery confirmed!'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to confirm delivery'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSectionLabel('VISUAL PROOF OF DELIVERY'),
                        const SizedBox(height: 16),
                        _buildImagePicker(),
                        const SizedBox(height: 32),
                        _buildSectionLabel('DELIVERY REMARKS'),
                        const SizedBox(height: 12),
                        _buildRemarksField(),
                        const SizedBox(height: 48),
                        _buildSubmitButton(),
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
                'Confirm Delivery',
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

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          image: _image != null
              ? DecorationImage(
                  image: FileImage(File(_image!.path)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 40,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CAPTURE BOUQUET PHOTO',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ensure the arrangement is clearly visible',
                    style: TextStyle(fontSize: 11, color: Colors.black26),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Icon(Icons.refresh_rounded, color: primaryColor),
                ),
              ),
      ),
    );
  }

  Widget _buildRemarksField() {
    return Container(
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
      child: TextField(
        controller: _remarksController,
        maxLines: 4,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Notes about the delivery location or recipient...',
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.2),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(24),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isUploading ? null : _confirmDelivery,
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
          child: _isUploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'CONFIRM DELIVERY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }
}
