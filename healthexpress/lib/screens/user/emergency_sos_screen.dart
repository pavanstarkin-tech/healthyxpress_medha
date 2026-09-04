import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/production_database.dart';
import '../../models/emergency_model.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  bool _sosTriggered = false;
  String? _dispatchedAmbulance;

  void _triggerSos(AmbulanceService amb) {
    setState(() {
      _sosTriggered = true;
      _dispatchedAmbulance = amb.providerName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.emergency,
        content: Text('🚨 SOS Alert Dispatched! ${amb.providerName} is en-route (ETA: ${amb.etaMinutes}).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.emergency),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Emergency Response (SOS)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.emergency)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big 3D Emergency SOS Banner (Matching Reference Image 3)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergency.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medical Emergency?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Instant ambulance dispatch 24/7', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Text('HIGH PRIORITY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Giant SOS Trigger Button
                  GestureDetector(
                    onTap: () => _triggerSos(ProductionDatabase.ambulances[0]),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emergency_rounded, color: AppColors.emergency, size: 42),
                            const SizedBox(height: 2),
                            Text(
                              _sosTriggered ? 'ACTIVE' : 'SOS',
                              style: const TextStyle(color: AppColors.emergency, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Tap to dispatch nearest emergency ambulance', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Location Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                    child: const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Current Location', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                        Text('Hitech City, Hyderabad, Telangana 500081', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Nearby Ambulance Services (Matching Reference Image 3 & 4)
            const Text('Nearby Ambulance Fleet (Real-Time ETA)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Column(
              children: ProductionDatabase.ambulances.map((amb) {
                final isDispatched = _dispatchedAmbulance == amb.providerName;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDispatched ? AppColors.emergency : AppColors.border, width: isDispatched ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.airport_shuttle_rounded, color: AppColors.emergency, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(amb.providerName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            Text('${amb.vehicleType} • ${amb.distanceKm} km', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                                  child: Text('ETA ${amb.etaMinutes}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                                ),
                                const SizedBox(width: 8),
                                Text(amb.estimatedFare == 0 ? 'Govt Free' : '₹${amb.estimatedFare.toInt()}',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _triggerSos(amb),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDispatched ? AppColors.success : AppColors.emergency,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isDispatched ? 'Dispatched' : 'Book', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Emergency Contacts Speed Dial (Matching Reference Image 4)
            const Text('Emergency Hotlines & Contacts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ContactDialButton(icon: Icons.local_hospital_rounded, label: 'Hospital\nHelpline', number: '1066'),
                _ContactDialButton(icon: Icons.person_rounded, label: 'Family\nDoctor', number: '+91 9848011223'),
                _ContactDialButton(icon: Icons.phone_in_talk_rounded, label: 'Emergency\nContact', number: '+91 9876543210'),
                _ContactDialButton(icon: Icons.shield_rounded, label: 'Police\nControl', number: '100'),
              ],
            ),
            const SizedBox(height: 24),

            // 108 Govt Emergency Call Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone_forwarded_rounded, color: AppColors.emergency, size: 28),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Feeling severe chest pain or breathlessness?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text('Call 108 for immediate free government medical ambulance.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dialing 108 Emergency Ambulance Response...')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emergency,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Call 108', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ContactDialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;

  const _ContactDialButton({required this.icon, required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling $number...')));
      },
      borderRadius: BorderRadius.circular(14),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
