import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_illustrations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'email_auth_screen.dart';
import '../user/user_main_nav.dart';
import '../doctor/doctor_main_nav.dart';
import '../doctor/doctor_onboarding_screen.dart';
import '../store/store_main_nav.dart';
import '../store/store_onboarding_screen.dart';

class AuthMethodScreen extends StatelessWidget {
  final UserRole role;
  const AuthMethodScreen({super.key, required this.role});

  String get _roleTitle {
    switch (role) {
      case UserRole.doctor:
        return '🩺 Doctor Portal';
      case UserRole.store:
        return '🏪 Store Partner';
      case UserRole.user:
      default:
        return '👤 Patient Account';
    }
  }

  Color get _roleColor {
    switch (role) {
      case UserRole.doctor:
        return AppColors.success;
      case UserRole.store:
        return const Color(0xFF0D9488);
      case UserRole.user:
      default:
        return AppColors.primary;
    }
  }

  Color get _roleBgColor {
    switch (role) {
      case UserRole.doctor:
        return const Color(0xFFDCFCE7);
      case UserRole.store:
        return const Color(0xFFCCFBF1);
      case UserRole.user:
      default:
        return AppColors.primaryLight;
    }
  }

  void _routeAfterLogin(BuildContext context) {
    if (role == UserRole.doctor) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DoctorMainNav()),
      );
    } else if (role == UserRole.store) {
      final store = context.read<AuthProvider>().currentStore;
      if (store.isVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StoreMainNav()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StoreOnboardingScreen()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserMainNav()),
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Role & Brand Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _roleBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _roleTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _roleColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: _roleColor.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3D Security Graphic
              Center(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Image.asset(
                    AppIllustrations.otpSecurity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const Text(
                'Sign In or Register',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in with your Google account or email and password.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // 1. Continue with Google (Firebase Google Login)
              InkWell(
                onTap: () async {
                  final auth = context.read<AuthProvider>();
                  try {
                    await auth.loginWithGoogle(role: role);
                    if (context.mounted) {
                      _routeAfterLogin(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red.shade700,
                          content: Text(e.toString().replaceAll('Exception: ', '')),
                        ),
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Icon(Icons.g_mobiledata_rounded, color: Colors.red, size: 30),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Instant Firebase 1-tap authentication',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 2. Continue with Email & Password (Firebase Email Auth)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmailAuthScreen(role: role),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: Icon(Icons.mail_outline_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Continue with Email & Password',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Firebase Email credentials & registration',
                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Or Create New Account / Direct Onboarding
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
                    role == UserRole.doctor
                        ? 'Complete Doctor Onboarding'
                        : (role == UserRole.store
                            ? 'Complete Store Onboarding'
                            : 'Create New Account'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _roleColor,
                    side: BorderSide(color: _roleColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (role == UserRole.doctor) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DoctorOnboardingScreen()),
                      );
                    } else if (role == UserRole.store) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StoreOnboardingScreen()),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EmailAuthScreen(role: role, initialSignUp: true)),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),

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
