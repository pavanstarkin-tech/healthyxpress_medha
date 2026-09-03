import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../data/mock_database.dart';
import 'doctor_consultation_notes_screen.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  final UserModel patient;
  const DoctorPatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Verified Patient Health File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Verified Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF047857)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('Aarogyasri ID: ${patient.aarogyasriId}', style: const TextStyle(color: Color(0xFF6EE7B7), fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('+91 ${patient.phone} • Verified Identity', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Critical Clinical Profile (Blood Group, Allergies, Surgeries)
            const Text('Clinical Profile & Medical History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Blood Group', value: patient.bloodGroup, isHighlight: true),
                  const Divider(height: 16, color: AppColors.border),
                  _InfoRow(label: 'Known Allergies', value: patient.allergies),
                  const Divider(height: 16, color: AppColors.border),
                  _InfoRow(label: 'Chronic Ailments', value: patient.chronicConditions),
                  const Divider(height: 16, color: AppColors.border),
                  _InfoRow(label: 'Past Surgeries & Procedures', value: patient.pastSurgeries),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Patient Live Vitals
            const Text('Current Health Vitals', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MiniVitalBox(
                    label: 'Temp',
                    value: '${patient.temperatureF}°F',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniVitalBox(
                    label: 'Pulse',
                    value: '${patient.heartRateBpm} bpm',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniVitalBox(
                    label: 'SpO2',
                    value: '${patient.oxygenSpo2}%',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniVitalBox(
                    label: 'Weight',
                    value: '${patient.weightKg.toInt()} kg',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Previous Lab Reports List
            const Text('Diagnostic Lab Reports', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: const [
                  _DocReportRow(title: 'Complete Blood Count (CBC)', date: '18 May 2024', status: 'Normal Platelets (2.4L)'),
                  Divider(height: 16, color: AppColors.border),
                  _DocReportRow(title: 'Dengue NS1 Antigen Test', date: '18 May 2024', status: 'Negative'),
                  Divider(height: 16, color: AppColors.border),
                  _DocReportRow(title: 'Lipid Profile', date: '12 Jan 2024', status: 'Optimal Cholesterol'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note_rounded, size: 20, color: Colors.white),
              label: const Text('Add Clinical Notes & Digital Prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DoctorConsultationNotesScreen(appointment: MockDatabase.initialAppointments.first),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoRow({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isHighlight ? AppColors.emergency : AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _MiniVitalBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniVitalBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _DocReportRow extends StatelessWidget {
  final String title;
  final String date;
  final String status;

  const _DocReportRow({required this.title, required this.date, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
        Text(status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success)),
      ],
    );
  }
}
