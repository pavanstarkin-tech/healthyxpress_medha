import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../user/user_main_nav.dart';

class BasicRegistrationScreen extends StatefulWidget {
  const BasicRegistrationScreen({super.key});

  @override
  State<BasicRegistrationScreen> createState() => _BasicRegistrationScreenState();
}

class _BasicRegistrationScreenState extends State<BasicRegistrationScreen> {
  final _nameController = TextEditingController(text: 'Rahul Kumar');
  final _ageController = TextEditingController(text: '28');
  final _phoneController = TextEditingController(text: '9876543210');
  final _emailController = TextEditingController(text: 'rahul.kumar@gmail.com');
  final _aarogyasriController = TextEditingController(text: 'AROG12345678');
  
  String _selectedGender = 'Male';
  bool _isFetchingLocation = false;
  String _detectedLocationAddress = 'Gachibowli, Hyderabad, Telangana (500081)';
  double _latitude = 17.440081;
  double _longitude = 78.348915;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aarogyasriController.dispose();
    super.dispose();
  }

  void _fetchCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    // Simulate real GPS lock + Mapbox Reverse Geocoding
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isFetchingLocation = false;
      _latitude = 17.440081;
      _longitude = 78.348915;
      _detectedLocationAddress = 'Financial District, Gachibowli, Hyderabad, Telangana - 500081';
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📍 Location mapped via Mapbox Live GPS!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _register() {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Name and Mobile Number')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.registerUser(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      aarogyasriId: _aarogyasriController.text.trim(),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const UserMainNav()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Patient Onboarding', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We use your details and live location to match nearby doctors, hospitals, and 15-minute medicine delivery.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              const Text('Full Name *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Rahul Kumar',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),

              // Age and Gender Row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Age *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'e.g. 28',
                            prefixIcon: Icon(Icons.cake_outlined, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedGender,
                              items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) => setState(() => _selectedGender = val ?? 'Male'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mobile Number
              const Text('Mobile Number *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: const Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  hintText: '10-digit mobile number',
                ),
              ),
              const SizedBox(height: 16),

              // Email Address
              const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'e.g. rahul.kumar@gmail.com',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 20),

              // Mapbox Live Location Permission & Resolution Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Live Location & Proximity (Mapbox)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                          ),
                        ),
                        InkWell(
                          onTap: _isFetchingLocation ? null : _fetchCurrentLocation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _isFetchingLocation
                                ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Refresh GPS', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _detectedLocationAddress,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'GPS: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)} • Unlocks nearest hospitals, doctors & 15-min delivery',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Aarogyasri ID (Optional)
              const Text('Aarogyasri / ABDM Health ID (Optional)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Syncs 50% subsidized procedures and government health benefits', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 6),
              TextField(
                controller: _aarogyasriController,
                decoration: const InputDecoration(
                  hintText: 'e.g. AROG12345678',
                  prefixIcon: Icon(Icons.qr_code_rounded, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Complete Onboarding & Enter App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
