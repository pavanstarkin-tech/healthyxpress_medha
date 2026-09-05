import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_illustrations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/pharmacy_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pharmacyProv = context.watch<PharmacyProvider>();
    final order = pharmacyProv.activeOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Tracking')),
        body: const Center(child: Text('No active orders.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
            Text('Order ID: ${order.orderId}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.headset_mic_rounded, color: AppColors.primary), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Out for Delivery', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Arriving in approx ${order.etaMinutes} at your doorstep', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Image.asset(
                    AppIllustrations.storeDeliveryBike,
                    height: 72,
                    width: 72,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Simulated Live Map Box (Matching Reference Image 3)
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  // Map grid background styling
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_rounded, size: 60, color: Colors.blue.shade200),
                        const SizedBox(height: 6),
                        Text('Live Delivery Route Mapbox', style: TextStyle(fontSize: 12, color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Delivery Scooter Marker
                  Positioned(
                    top: 60,
                    left: 90,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 20),
                    ),
                  ),

                  // Destination Home Marker
                  Positioned(
                    bottom: 30,
                    right: 60,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.emergency, shape: BoxShape.circle),
                      child: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 4-Step Timeline Stepper (Matching Reference Image 3)
            const Text('Delivery Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _TimelineStep(
                    title: 'Order Confirmed',
                    time: '10:30 AM',
                    isDone: true,
                    isFirst: true,
                  ),
                  _TimelineStep(
                    title: 'Packed by Pharmacy Partner',
                    time: '10:35 AM',
                    isDone: true,
                  ),
                  _TimelineStep(
                    title: 'Out for Delivery',
                    time: '10:45 AM',
                    isDone: true,
                    isActive: true,
                  ),
                  _TimelineStep(
                    title: 'Delivered to Doorstep',
                    time: 'Estimated 11:05 AM',
                    isDone: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Delivery Partner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.driverName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const Text('Express Delivery Partner • Vaccinated', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${order.driverName} at ${order.driverPhone}')));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final String time;
  final bool isDone;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.time,
    required this.isDone,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? AppColors.success : (isActive ? AppColors.primary : Colors.grey.shade300),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check_rounded : (isActive ? Icons.two_wheeler_rounded : Icons.circle),
                color: Colors.white,
                size: 13,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: isDone ? AppColors.success : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
                    color: isDone || isActive ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
