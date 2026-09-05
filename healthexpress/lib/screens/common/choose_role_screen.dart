import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_illustrations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'auth_method_screen.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  UserRole _selectedRole = UserRole.user;

  Color get _activeThemeColor {
    switch (_selectedRole) {
      case UserRole.user:
        return AppColors.primary;
      case UserRole.doctor:
        return AppColors.success;
      case UserRole.store:
        return const Color(0xFF0D9488);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join HealthExpress',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your account role to continue with a personalized experience.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // 1. User / Patient Card Option
              _buildRoleCard(
                role: UserRole.user,
                title: "I'm a User / Patient",
                description: 'AI diagnosis, doctor consultations, quick medicine delivery & Aarogyasri ID.',
                illustrationAsset: AppIllustrations.rolePatient,
                icon: Icons.person_rounded,
                activeBgColor: AppColors.primaryLight,
                activeBorderColor: AppColors.primary,
                iconBgColor: AppColors.primary,
              ),
              const SizedBox(height: 16),

              // 2. Doctor Card Option
              _buildRoleCard(
                role: UserRole.doctor,
                title: "I'm a Doctor",
                description: 'Hospital affiliation, patient consultations, Aarogyasri scan & earnings ledger.',
                illustrationAsset: AppIllustrations.roleDoctor,
                icon: Icons.medical_services_rounded,
                activeBgColor: const Color(0xFFF0FDF4),
                activeBorderColor: AppColors.success,
                iconBgColor: AppColors.success,
              ),
              const SizedBox(height: 16),

              // 3. Store Partner / Pharmacy Card Option
              _buildRoleCard(
                role: UserRole.store,
                title: "I'm a Medical Store Partner",
                description: 'Manage 15-min medicine delivery, drug inventory, opening hours & store orders.',
                illustrationAsset: AppIllustrations.roleStore,
                icon: Icons.local_pharmacy_rounded,
                activeBgColor: const Color(0xFFF0FDFA),
                activeBorderColor: const Color(0xFF0D9488),
                iconBgColor: const Color(0xFF0D9488),
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthProvider>().setRole(_selectedRole);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AuthMethodScreen(role: _selectedRole),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _activeThemeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String description,
    required String illustrationAsset,
    required IconData icon,
    required Color activeBgColor,
    required Color activeBorderColor,
    required Color iconBgColor,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeBorderColor : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? activeBorderColor.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 14 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : iconBgColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? activeBorderColor.withValues(alpha: 0.3) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  illustrationAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    icon,
                    size: 28,
                    color: iconBgColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? activeBorderColor : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
