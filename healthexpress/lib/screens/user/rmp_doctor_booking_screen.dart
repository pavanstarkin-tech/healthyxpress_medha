import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/production_database.dart';
import 'book_appointment_screen.dart';

class RmpDoctorBookingScreen extends StatefulWidget {
  const RmpDoctorBookingScreen({super.key});

  @override
  State<RmpDoctorBookingScreen> createState() => _RmpDoctorBookingScreenState();
}

class _RmpDoctorBookingScreenState extends State<RmpDoctorBookingScreen> {
  final List<String> _selectedTreatments = ['Injection / Saline', 'Fever & Vitals Check'];

  final List<String> _treatments = [
    'Injection / Saline',
    'Fever & Vitals Check',
    'Wound Dressing & Bandage',
    'Blood Sample Collection',
    'Nebulization Therapy',
    'Post-Surgery Home Care',
  ];

  @override
  Widget build(BuildContext context) {
    final rmpDocs = ProductionDatabase.doctors.where((d) => d.isRmpDoctor || d.supportedTypes.contains(ConsultationType.homeVisitRMP)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Doorstep RMP Doctor Visit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Immediate Home Doctor Visit', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Certified practitioners arrive at your home within 25-40 mins with medical kit & basic medicines.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.home_repair_service_rounded, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select Required Home Treatments
            const Text('Select Required Home Services', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _treatments.map((t) {
                final isSelected = _selectedTreatments.contains(t);
                return FilterChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedTreatments.add(t);
                      } else {
                        _selectedTreatments.remove(t);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFCCFBF1),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF0F766E) : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: isSelected ? const Color(0xFF0D9488) : AppColors.border)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Available Nearby RMP Doctors
            const Text('Available Nearby Doorstep Doctors', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Column(
              children: rmpDocs.map((doc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(doc.photoUrl),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text('${doc.specialty} • ${doc.experienceYears}+ Yrs Exp', style: const TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.near_me_rounded, size: 12, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text('${doc.distanceKm} km • Arrives in 25 mins', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('₹${doc.homeVisitFee.toInt()} / home visit', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => BookAppointmentScreen(doctor: doc)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Book Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
