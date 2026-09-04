import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/ai_assistant_provider.dart';
import 'ai_assistant_screen.dart';
import 'doctor_search_screen.dart';
import 'hospital_search_screen.dart';
import 'pharmacy_screen.dart';
import 'lab_tests_screen.dart';
import 'rmp_doctor_booking_screen.dart';
import 'emergency_sos_screen.dart';
import 'health_records_screen.dart';
import 'health_vitals_dashboard_screen.dart';
import 'my_appointments_screen.dart';
import 'medication_reminders_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ai = context.watch<AiAssistantProvider>();
    final appointmentProv = context.watch<AppointmentProvider>();
    final nextAppointment = appointmentProv.getNextUpcoming();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar (Brand, Bell, User Photo)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Image.asset('assets/images/app_logo.png', fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'HealthExpress AI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textPrimary),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 1.5),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Greeting
              Text(
                'Hello, ${auth.currentUser.name.split(' ').first} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'How can I help you today?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),

              // AI Health Assistant Banner (Matching Reference Image 2)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E60F6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'Gemini Clinical AI',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'AI Health Assistant',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'I can help you with symptoms, medicines, doctors and more.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Chat with AI',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 3D Robot Mascot Container
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.smart_toy_rounded,
                          size: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Quick Actions Grid Header
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // 4x2 Grid of Actions (Matching Reference Image 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionButton(
                    icon: Icons.person_search_rounded,
                    label: 'Find Doctor',
                    color: const Color(0xFF3B82F6),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DoctorSearchScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.apartment_rounded,
                    label: 'Hospitals',
                    color: const Color(0xFF06B6D4),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HospitalSearchScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.medication_rounded,
                    label: 'Medicines',
                    color: const Color(0xFFF97316),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PharmacyScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.biotech_rounded,
                    label: 'Lab Tests',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LabTestsScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionButton(
                    icon: Icons.home_repair_service_rounded,
                    label: 'RMP Doctor',
                    color: const Color(0xFF10B981),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RmpDoctorBookingScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.emergency_rounded,
                    label: 'Ambulance',
                    color: const Color(0xFFEF4444),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencySosScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.description_rounded,
                    label: 'Health Records',
                    color: const Color(0xFF0EA5E9),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HealthRecordsScreen())),
                  ),
                  _QuickActionButton(
                    icon: Icons.monitor_heart_rounded,
                    label: 'Health Vitals',
                    color: const Color(0xFFEC4899),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HealthVitalsDashboardScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dynamic Disease Category Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Symptom Filter',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    'Current: ${ai.activeDiagnosis}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ConditionChip(
                      label: 'Fever',
                      isSelected: ai.activeDiagnosis.contains('Fever'),
                      onTap: () => ai.selectCondition('Fever'),
                    ),
                    const SizedBox(width: 8),
                    _ConditionChip(
                      label: 'Cold & Cough',
                      isSelected: ai.activeDiagnosis.contains('Cold') || ai.activeDiagnosis.contains('Cough'),
                      onTap: () => ai.selectCondition('Cold & Cough'),
                    ),
                    const SizedBox(width: 8),
                    _ConditionChip(
                      label: 'Migraine',
                      isSelected: ai.activeDiagnosis.contains('Migraine'),
                      onTap: () => ai.selectCondition('Migraine'),
                    ),
                    const SizedBox(width: 8),
                    _ConditionChip(
                      label: 'Cardiology',
                      isSelected: ai.activeDiagnosis.contains('Cardiac'),
                      onTap: () => ai.selectCondition('Cardiac Alert / Emergency'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Health Summary Header & Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Health Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyAppointmentsScreen())),
                    child: const Text('View all', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Upcoming Appointment Card
              if (nextAppointment != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF7C3AED), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Upcoming Appointment', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(
                              '${nextAppointment.doctorName} • ${nextAppointment.hospitalName}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${nextAppointment.dateTime.day} May 2024, ${nextAppointment.timeSlot}',
                              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              const SizedBox(height: 12),

              // Medicine Reminder Card
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MedicationRemindersScreen())),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.alarm_on_rounded, color: Color(0xFF0284C7), size: 24),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Medicine Reminder', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('2 Medicines due today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            SizedBox(height: 2),
                            Text('Paracetamol 650mg after lunch', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConditionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
