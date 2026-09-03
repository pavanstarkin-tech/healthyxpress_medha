import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'email_auth_screen.dart';
import 'mobile_otp_screen.dart';
import 'basic_registration_screen.dart';
import '../user/user_main_nav.dart';
import '../doctor/doctor_main_nav.dart';
import '../doctor/doctor_onboarding_screen.dart';

class AuthMethodScreen extends StatelessWidget {
  final UserRole role;
  const AuthMethodScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isDoctor = role == UserRole.doctor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDoctor ? const Color(0xFFDCFCE7) : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isDoctor ? '🩺 Doctor Portal' : '👤 Patient Account',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDoctor ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign In or Register',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your preferred authentication method to continue.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // Continue with Google
              _AuthButton(
                icon: Icons.g_mobiledata_rounded,
                iconColor: Colors.red,
                iconSize: 34,
                title: 'Continue with Google',
                onTap: () {
                  final auth = context.read<AuthProvider>();
                  auth.login(identifier: 'Google User', role: role);
                  if (isDoctor) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const DoctorMainNav()),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const UserMainNav()),
                    );
                  }
                },
              ),
              const SizedBox(height: 14),

              // Continue with Mobile & OTP
              _AuthButton(
                icon: Icons.phone_android_rounded,
                iconColor: AppColors.primary,
                title: 'Continue with Mobile OTP',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MobileOtpScreen(role: role),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Continue with Email
              _AuthButton(
                icon: Icons.mail_outline_rounded,
                iconColor: Colors.deepPurple,
                title: 'Continue with Email',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmailAuthScreen(role: role),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Or Create New Account
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                  label: Text(
                    isDoctor ? 'Complete Doctor Onboarding' : 'New User Minimal Registration',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDoctor ? AppColors.success : AppColors.primary,
                    side: BorderSide(color: isDoctor ? AppColors.success : AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (isDoctor) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DoctorOnboardingScreen()),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BasicRegistrationScreen()),
                      );
                    }
                  },
                ),
              ),

              const Spacer(),
              Center(
                child: Text(
                  'By continuing, you agree to HealthExpress AI Terms of Service & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String title;
  final VoidCallback onTap;

  const _AuthButton({
    required this.icon,
    required this.iconColor,
    this.iconSize = 22,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: iconSize),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
