import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_illustrations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'store_pending_approval_screen.dart';

class StoreOnboardingScreen extends StatefulWidget {
  const StoreOnboardingScreen({super.key});

  @override
  State<StoreOnboardingScreen> createState() => _StoreOnboardingScreenState();
}

class _StoreOnboardingScreenState extends State<StoreOnboardingScreen> {
  final _nameController = TextEditingController(text: 'MedPlus Express Pharmacy');
  final _licenseController = TextEditingController(text: 'TS-HYD-PHARM-2026-9421');
  final _phoneController = TextEditingController(text: '9848099881');
  final _emailController = TextEditingController(text: 'contact@medplusexpress.com');
  final _addressController = TextEditingController(text: 'Plot 42, Silicon Valley Rd, Madhapur');
  final _areaController = TextEditingController(text: 'Madhapur, Hyderabad');
  final _openingTimeController = TextEditingController(text: '08:00 AM');
  final _closingTimeController = TextEditingController(text: '11:00 PM');

  bool _is24x7 = true;
  String _selectedPresetImage = 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400';

  final List<Map<String, String>> _storePresets = [
    {
      'label': 'Modern Chemist',
      'url': 'https://images.unsplash.com/photo-1576602976047-174e57a47881?auto=format&fit=crop&q=80&w=400'
    },
    {
      'label': 'Superstore Pharmacy',
      'url': 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&q=80&w=400'
    },
    {
      'label': 'Dark Store Hub',
      'url': 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&q=80&w=400'
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  void _submitOnboarding() {
    if (_nameController.text.trim().isEmpty ||
        _licenseController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields (Name, License, Phone, Address)')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.registerStore(
      name: _nameController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      area: _areaController.text.trim(),
      openingTime: _openingTimeController.text.trim(),
      closingTime: _closingTimeController.text.trim(),
      is24x7: _is24x7,
      imageUrl: _selectedPresetImage,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StorePendingApprovalScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Store Partner Onboarding',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      AppIllustrations.storeOnboarding,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_pharmacy_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join HealthExpress 15-Min Network',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Submit your drug license & store details for instant Super Admin verification.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Store Info Form
            const Text(
              'Store Credentials & Identification',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            _buildTextField(
              controller: _nameController,
              label: 'Pharmacy / Store Name *',
              hint: 'e.g. MedPlus Pharmacy or Apollo Chemist',
              icon: Icons.store_rounded,
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _licenseController,
              label: 'State Drug License (DL) Number *',
              hint: 'e.g. TS-HYD-PHARM-2026-XXXX',
              icon: Icons.verified_user_rounded,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _phoneController,
                    label: 'Store Contact Phone *',
                    hint: '98480XXXXX',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _emailController,
                    label: 'Store Email',
                    hint: 'store@pharmacy.com',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _addressController,
              label: 'Physical Address *',
              hint: 'Plot No, Street, Landmark',
              icon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 14),

            _buildTextField(
              controller: _areaController,
              label: 'Area & City *',
              hint: 'e.g. Madhapur, Hyderabad',
              icon: Icons.map_rounded,
            ),
            const SizedBox(height: 24),

            // Timings & Operations
            const Text(
              'Operating Hours & Delivery Dispatch',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24x7 Night Delivery Store',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Store operates round-the-clock for emergency 15-min delivery',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: _is24x7,
                    onChanged: (val) => setState(() => _is24x7 = val),
                    activeColor: const Color(0xFF0D9488),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (!_is24x7)
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _openingTimeController,
                      label: 'Opening Time',
                      hint: '08:00 AM',
                      icon: Icons.access_time_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _closingTimeController,
                      label: 'Closing Time',
                      hint: '11:00 PM',
                      icon: Icons.access_time_filled_rounded,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Store Front Photo Preset
            const Text(
              'Storefront Preset Photo',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Row(
              children: _storePresets.map((preset) {
                final isSelected = _selectedPresetImage == preset['url'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPresetImage = preset['url']!),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF0D9488) : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              preset['url']!,
                              height: 60,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            preset['label']!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? const Color(0xFF0D9488) : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitOnboarding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: const Text(
                  'Submit Store for Verification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF0D9488)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
