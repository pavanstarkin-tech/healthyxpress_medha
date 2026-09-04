import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../data/production_database.dart';
import 'doctor_main_nav.dart';

class DoctorOnboardingScreen extends StatefulWidget {
  const DoctorOnboardingScreen({super.key});

  @override
  State<DoctorOnboardingScreen> createState() => _DoctorOnboardingScreenState();
}

class _DoctorOnboardingScreenState extends State<DoctorOnboardingScreen> {
  final _nameController = TextEditingController(text: 'Dr. Sandeep Attawar');
  final _phoneController = TextEditingController(text: '9848011223');
  final _regNumController = TextEditingController(text: 'MCI-TS-2012-88421');
  final _qualificationsController = TextEditingController(text: 'MBBS, MD, DM (Cardiology)');
  final _feeController = TextEditingController(text: '800');

  String _selectedSpecialty = 'Cardiologist';
  String _selectedHospitalId = 'HOSP-01'; // Default: KIMS Hospitals
  bool _isIndependent = false;

  final List<String> _specialties = [
    'Cardiologist',
    'Neurologist',
    'Orthopedic Surgeon',
    'Gynecologist',
    'General Physician',
    'ENT Specialist',
    'Pediatrician',
    'RMP Doctor (Home Visit)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _regNumController.dispose();
    _qualificationsController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all mandatory fields.')));
      return;
    }

    final hospitalName = _isIndependent
        ? 'Independent Practice'
        : ProductionDatabase.hospitals.firstWhere((h) => h.id == _selectedHospitalId).name;

    final auth = context.read<AuthProvider>();
    auth.registerDoctor(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      specialty: _selectedSpecialty,
      qualifications: _qualificationsController.text.trim(),
      hospitalId: _isIndependent ? 'INDEP-01' : _selectedHospitalId,
      hospitalName: hospitalName,
      clinicFee: double.tryParse(_feeController.text.trim()) ?? 800.0,
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DoctorMainNav()),
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
        title: const Text('Doctor Registration & Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Verification Flow Progress Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Doctor Status: Active & KYC Verified (MCI / State Council)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Doctor Name *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'e.g. Dr. Sandeep Attawar'),
              ),
              const SizedBox(height: 16),

              const Text('Mobile Number *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '10-digit mobile number'),
              ),
              const SizedBox(height: 16),

              const Text('Specialty *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                decoration: const InputDecoration(),
                items: _specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSpecialty = val ?? _selectedSpecialty),
              ),
              const SizedBox(height: 16),

              const Text('Medical Council Reg No *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _regNumController,
                decoration: const InputDecoration(hintText: 'e.g. MCI-TS-2012-88421'),
              ),
              const SizedBox(height: 16),

              const Text('Qualifications *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _qualificationsController,
                decoration: const InputDecoration(hintText: 'e.g. MBBS, MD, DM (Cardiology)'),
              ),
              const SizedBox(height: 20),

              // Hospital Affiliation Selection (Per requirements in idea.txt and plan.txt)
              const Text('Hospital Affiliation Selection *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Choose an admin-approved hospital or Independent Practice', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 8),

              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Admin Hospital List'),
                    selected: !_isIndependent,
                    onSelected: (val) => setState(() => _isIndependent = false),
                    selectedColor: AppColors.success,
                    labelStyle: TextStyle(color: !_isIndependent ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Independent Practice'),
                    selected: _isIndependent,
                    onSelected: (val) => setState(() => _isIndependent = true),
                    selectedColor: AppColors.success,
                    labelStyle: TextStyle(color: _isIndependent ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (!_isIndependent)
                DropdownButtonFormField<String>(
                  value: _selectedHospitalId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.apartment_rounded, color: AppColors.textMuted),
                  ),
                  items: ProductionDatabase.hospitals
                      .map((h) => DropdownMenuItem(value: h.id, child: Text('${h.name} (${h.location})', style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedHospitalId = val ?? _selectedHospitalId),
                ),
              const SizedBox(height: 16),

              const Text('Consultation Fee (₹) *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'e.g. 800'),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Complete Setup & Enter Dashboard', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
