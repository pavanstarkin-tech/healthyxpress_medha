import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../user/user_main_nav.dart';
import '../doctor/doctor_main_nav.dart';

class MobileOtpScreen extends StatefulWidget {
  final UserRole role;
  const MobileOtpScreen({super.key, required this.role});

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController(text: ''));
  bool _otpSent = false;
  int _resendTimer = 30;

  @override
  void initState() {
    super.initState();
    // Default prefill OTP for seamless demo testing
    _otpControllers[0].text = '5';
    _otpControllers[1].text = '2';
    _otpControllers[2].text = '9';
    _otpControllers[3].text = '4';
    _otpControllers[4].text = '1';
    _otpControllers[5].text = '0';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyAndProceed() {
    final auth = context.read<AuthProvider>();
    auth.login(identifier: _phoneController.text, role: widget.role);
    if (widget.role == UserRole.doctor) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DoctorMainNav()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const UserMainNav()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.role == UserRole.doctor;

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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _otpSent ? 'Enter 6-Digit OTP' : 'Mobile Verification',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _otpSent
                    ? 'We have sent a verification code to +91 ${_phoneController.text}'
                    : 'We will send you a one-time verification code.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              if (!_otpSent) ...[
                const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: const Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    hintText: 'Enter 10-digit mobile number',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _otpSent = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDoctor ? AppColors.success : AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Get OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ] else ...[
                // 6 OTP Digit Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        controller: _otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.primaryLight.withValues(alpha: 0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resend in $_resendTimer s',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _resendTimer = 30),
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: isDoctor ? AppColors.success : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _verifyAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDoctor ? AppColors.success : AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Verify & Continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
