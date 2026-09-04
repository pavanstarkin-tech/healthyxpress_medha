import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/doctor_portal_provider.dart';
import '../../data/production_database.dart';
import 'doctor_patient_detail_screen.dart';

class DoctorPatientQrScannerScreen extends StatefulWidget {
  const DoctorPatientQrScannerScreen({super.key});

  @override
  State<DoctorPatientQrScannerScreen> createState() => _DoctorPatientQrScannerScreenState();
}

class _DoctorPatientQrScannerScreenState extends State<DoctorPatientQrScannerScreen> {
  final _manualIdController = TextEditingController(text: 'AROG12345678');

  void _onScanSuccess(String token) {
    context.read<DoctorPortalProvider>().lookupPatientByAarogyasriQR(token);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorPatientDetailScreen(patient: ProductionDatabase.defaultUser),
      ),
    );
  }

  @override
  void dispose() {
    _manualIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Aarogyasri (RGIS) QR Scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Scan Patient Health Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'Align the patient QR code inside the viewfinder to securely retrieve past surgical history, lab reports, and medication history.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 30),

              // Viewfinder Container
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF10B981), width: 3),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Scanner Corner Accents
                      const Positioned(top: 12, left: 12, child: Icon(Icons.crop_free_rounded, color: Color(0xFF10B981), size: 32)),
                      const Positioned(top: 12, right: 12, child: Icon(Icons.crop_free_rounded, color: Color(0xFF10B981), size: 32)),
                      const Positioned(bottom: 12, left: 12, child: Icon(Icons.crop_free_rounded, color: Color(0xFF10B981), size: 32)),
                      const Positioned(bottom: 12, right: 12, child: Icon(Icons.crop_free_rounded, color: Color(0xFF10B981), size: 32)),

                      // Laser Scan Animation Line
                      Container(
                        height: 2,
                        width: 200,
                        color: const Color(0xFF10B981),
                      ),

                      // Instant Tap-To-Simulate Scanner
                      InkWell(
                        onTap: () => _onScanSuccess('AROG12345678'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text('Tap to Scan QR Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Manual Aarogyasri ID Lookup
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Or Enter Aarogyasri Number Manually', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _manualIdController,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'e.g. AROG12345678',
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.1),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _onScanSuccess(_manualIdController.text.trim()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Lookup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
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
