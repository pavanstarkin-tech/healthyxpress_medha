import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/vision_analysis_model.dart';
import 'user_home_screen.dart';
import 'my_appointments_screen.dart';
import 'ai_assistant_screen.dart';
import 'ai_lens_scanner_screen.dart';
import 'nearby_hospitals_map_screen.dart';
import 'user_profile_screen.dart';

class UserMainNav extends StatefulWidget {
  final int initialIndex;
  const UserMainNav({super.key, this.initialIndex = 0});

  @override
  State<UserMainNav> createState() => _UserMainNavState();
}

class _UserMainNavState extends State<UserMainNav> {
  late int _currentIndex;
  bool _isCenterHovered = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    UserHomeScreen(),
    MyAppointmentsScreen(),
    AiAssistantScreen(), // Center AI Assistant
    NearbyHospitalsMapScreen(),
    UserProfileScreen(),
  ];

  void _showAiCenterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: AppColors.aiAssistantGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HealthExpress AI Suite',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          'Select AI Service or Camera Vision Scanner',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Option 1: AI Lens Food & Calories
                _ActionTile(
                  icon: Icons.camera_alt_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFEF3C7),
                  title: 'AI Lens: Snap Food & Calories',
                  subtitle: 'Groq Vision calculates calories, nutrients, glycemic index & dishes',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AiLensScannerScreen(initialScope: VisionScope.food),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Option 2: AI Lens Medicine & Tablet Scanner
                _ActionTile(
                  icon: Icons.medication_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFDBEAFE),
                  title: 'AI Lens: Snap Tablets / Medicines',
                  subtitle: 'Strict Medical Scope: Chemical molecule, clinical uses & precautions',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AiLensScannerScreen(initialScope: VisionScope.medicine),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Option 3: Full AI Health Assistant
                _ActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: const Color(0xFF0D9488),
                  iconBg: const Color(0xFFCCFBF1),
                  title: 'Full AI Health Assistant & Voice',
                  subtitle: 'Multilingual symptom checker, Sarvam voice & health Q&A',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() => _currentIndex = 2);
                  },
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: const Border(
            top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Appointments',
                    isSelected: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),

                // Center AI Assistant Hero Button with Elevated Glow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isCenterHovered = true),
                    onExit: (_) => setState(() => _isCenterHovered = false),
                    child: GestureDetector(
                      onTap: _showAiCenterMenu,
                      child: Transform.translate(
                        offset: const Offset(0, -10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          transform: Matrix4.diagonal3Values(
                            _isCenterHovered ? 1.08 : 1.0,
                            _isCenterHovered ? 1.08 : 1.0,
                            1.0,
                          ),
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF7C3AED), Color(0xFF06B6D4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: _isCenterHovered ? 0.65 : 0.42),
                                blurRadius: _isCenterHovered ? 20 : 14,
                                spreadRadius: _isCenterHovered ? 3 : 1,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF1E40AF), Color(0xFF4F46E5)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: _NavItem(
                    icon: Icons.local_hospital_rounded,
                    label: 'Hospitals',
                    isSelected: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: _currentIndex == 4,
                    onTap: () => setState(() => _currentIndex = 4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 12 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              icon,
              size: isSelected ? 23 : 22,
              color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                letterSpacing: isSelected ? 0.1 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
