import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../doctor/doctor_main_nav.dart';
import '../doctor/doctor_onboarding_screen.dart';
import '../common/welcome_screen.dart';
import 'health_records_screen.dart';
import 'my_appointments_screen.dart';
import 'medication_reminders_screen.dart';
import 'support_ticket_screen.dart';
import 'emergency_sos_screen.dart';
import 'order_tracking_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          children: [
            // User Header Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(user.email.isNotEmpty ? user.email : '+91 ${user.phone}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                          child: Text('Firebase ID: ${user.id.length > 12 ? user.id.substring(0, 12) + "..." : user.id}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Role Switch to Doctor Banner
            InkWell(
              onTap: () {
                auth.setRole(UserRole.doctor);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DoctorMainNav()),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Switch to Doctor Portal', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Manage hospital slots, QR scan patient records & consultations', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Menu Items List
            _ProfileMenuItem(
              icon: Icons.qr_code_2_rounded,
              iconColor: AppColors.primary,
              title: 'Aarogyasri (RGIS) & Health Records',
              subtitle: 'Digital pass, lab reports, past surgeries',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HealthRecordsScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.calendar_month_rounded,
              iconColor: Colors.purple,
              title: 'My Appointments',
              subtitle: 'Upcoming, completed, and rescheduled slots',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyAppointmentsScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.alarm_on_rounded,
              iconColor: Colors.orange,
              title: 'Medication Progress & Reminders',
              subtitle: 'Daily pill tracker and adherence streak',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MedicationRemindersScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.delivery_dining_rounded,
              iconColor: Colors.teal,
              title: 'Pharmacy Orders & Live Tracking',
              subtitle: 'Track quick medicines delivery status',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderTrackingScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.emergency_rounded,
              iconColor: AppColors.emergency,
              title: 'Emergency SOS & Hotlines',
              subtitle: 'Ambulance dispatch & 108 speed dial',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencySosScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.support_agent_rounded,
              iconColor: Colors.indigo,
              title: 'Help & Support Tickets',
              subtitle: 'Raise tickets for bookings, billing, or app issues',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportTicketScreen())),
            ),
            _ProfileMenuItem(
              icon: Icons.medical_information_rounded,
              iconColor: Colors.blue,
              title: 'Doctor Onboarding Registration',
              subtitle: 'Register as verified hospital or independent doctor',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DoctorOnboardingScreen())),
            ),
            const SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                label: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  auth.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textMuted),
      ),
    );
  }
}
