import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/production_database.dart';
import '../../models/doctor_model.dart';
import '../../models/hospital_model.dart';
import '../../models/medicine_model.dart';
import '../../models/lab_test_model.dart';
import '../../providers/ai_assistant_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pharmacy_provider.dart';
import 'book_appointment_screen.dart';
import 'hospital_detail_screen.dart';
import 'lab_tests_screen.dart';
import 'cart_checkout_screen.dart';
import 'emergency_sos_screen.dart';
import 'ai_voice_call_screen.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final auth = context.read<AuthProvider>();
        context.read<AiAssistantProvider>().seedUserContext(auth.currentUser);
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = (customText ?? _textController.text).trim();
    if (text.isEmpty) return;
    _textController.clear();
    final prov = context.read<AiAssistantProvider>();
    prov.addUserMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleOrderMedicine(MedicineModel med) {
    context.read<PharmacyProvider>().addToCart(med);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text('Added ${med.name} to Pharmacy Cart!')),
          ],
        ),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartCheckoutScreen()));
          },
        ),
      ),
    );
  }

  void _handleBookDoctor(DoctorModel doc) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BookAppointmentScreen(doctor: doc)),
    );
  }

  void _handleViewHospital(HospitalModel hosp) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HospitalDetailScreen(hospital: hosp)),
    );
  }

  void _handleBookLabTest(LabTestModel test) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LabTestsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final aiProv = context.watch<AiAssistantProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.aiAssistantGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HealthExpress AI Doctor', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text(
                    aiProv.isLiveVoiceMode
                        ? 'LiveKit Live Audio Call Active'
                        : (aiProv.selectedLanguage == 'te' ? 'క్లినికల్ ట్రయేజ్ & సంరక్షణ' : (aiProv.selectedLanguage == 'hi' ? 'क्लीनिकल ट्राइएज और देखभाल' : 'Multilingual Clinical Triage')),
                    style: TextStyle(fontSize: 11, color: aiProv.isLiveVoiceMode ? const Color(0xFF10B981) : AppColors.textSecondary, fontWeight: aiProv.isLiveVoiceMode ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Live Voice Call Mode Button
          IconButton(
            tooltip: 'Live Voice Call (Doctor)',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFF10B981), size: 18),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiVoiceCallScreen()),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Top Language Selection Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(bottom: BorderSide(color: AppColors.border)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.translate_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                const Text('Language:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const Spacer(),
                _LanguageChip(
                  label: 'English',
                  code: 'en',
                  isSelected: aiProv.selectedLanguage == 'en',
                  onTap: () => aiProv.setLanguage('en'),
                ),
                _LanguageChip(
                  label: 'తెలుగు (Telugu)',
                  code: 'te',
                  isSelected: aiProv.selectedLanguage == 'te',
                  onTap: () => aiProv.setLanguage('te'),
                ),
                _LanguageChip(
                  label: 'हिंदी (Hindi)',
                  code: 'hi',
                  isSelected: aiProv.selectedLanguage == 'hi',
                  onTap: () => aiProv.setLanguage('hi'),
                ),
              ],
            ),
          ),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: aiProv.messages.length,
              itemBuilder: (context, index) {
                final msg = aiProv.messages[index];
                return _MessageBubble(
                  message: msg,
                  onSuggestionTap: (sugg) => _sendMessage(sugg),
                  onOrderMedicine: _handleOrderMedicine,
                  onBookDoctor: _handleBookDoctor,
                  onViewHospital: _handleViewHospital,
                  onBookLabTest: _handleBookLabTest,
                  onEmergencySos: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencySosScreen()));
                  },
                );
              },
            ),
          ),

          // Analyzing / Thinking Indicator
          if (aiProv.isThinking)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          aiProv.selectedLanguage == 'te'
                              ? 'వైద్య విశ్లేషణ జరుగుతోంది...'
                              : (aiProv.selectedLanguage == 'hi' ? 'चिकित्सा विश्लेषण जारी है...' : 'Clinical AI analyzing symptoms...'),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Voice Listening Waveform Banner (Active when listening)
          if (aiProv.isListening)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: AppColors.emergency,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mic, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aiProv.selectedLanguage == 'te' ? '🎙️ మీ మాటలు వినబడుతున్నాయి...' : '🎙️ Listening to your voice in real time...',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          aiProv.liveTranscription,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => aiProv.toggleVoiceListening(),
                    child: const Text('Cancel', style: TextStyle(color: AppColors.emergency, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),

          // Voice & Text Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Voice Mic Button with Pulsing Glow
                  GestureDetector(
                    onTap: () => aiProv.toggleVoiceListening(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: aiProv.isListening
                            ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                            : AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (aiProv.isListening ? AppColors.emergency : AppColors.primary).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        aiProv.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: aiProv.selectedLanguage == 'te'
                            ? 'లక్షణాలు టైప్ చేయండి లేదా మాట్లాడండి...'
                            : (aiProv.selectedLanguage == 'hi' ? 'लक्षण टाइप करें या बोलें...' : 'Type symptoms or tap mic to speak...'),
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Action Button
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onSuggestionTap;
  final Function(MedicineModel) onOrderMedicine;
  final Function(DoctorModel) onBookDoctor;
  final Function(HospitalModel) onViewHospital;
  final Function(LabTestModel) onBookLabTest;
  final VoidCallback onEmergencySos;

  const _MessageBubble({
    required this.message,
    required this.onSuggestionTap,
    required this.onOrderMedicine,
    required this.onBookDoctor,
    required this.onViewHospital,
    required this.onBookLabTest,
    required this.onEmergencySos,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.isAudio) ...[
                      const Icon(Icons.mic, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        message.text,
                        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 18),
            ),
          ],
        ),
      );
    }

    // AI Message
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              gradient: AppColors.aiAssistantGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formatted Markdown Text with TTS Speaker Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _MarkdownFormattedText(text: message.text),
                      ),
                      const SizedBox(width: 6),
                      Consumer<AiAssistantProvider>(
                        builder: (context, ai, _) {
                          final isThisSpeaking = ai.isSpeaking;
                          return Tooltip(
                            message: isThisSpeaking ? 'Stop Audio' : 'Listen to AI Response (Speaker)',
                            child: GestureDetector(
                              onTap: () {
                                if (ai.isSpeaking) {
                                  ai.stopSpeaking();
                                } else {
                                  ai.speakText(message.text);
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isThisSpeaking
                                      ? AppColors.primary
                                      : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                  boxShadow: isThisSpeaking
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_up_outlined,
                                  color: isThisSpeaking ? Colors.white : AppColors.primary,
                                  size: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 0. DYNAMIC ACTION CARDS (Confirmed Bookings, Live Tracking, Emergency SOS)
                  if (message.dynamicCards != null && message.dynamicCards!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    ...message.dynamicCards!.map((card) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: card.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: card.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: card.color, shape: BoxShape.circle),
                              child: Icon(card.icon, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(card.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: card.color)),
                                  const SizedBox(height: 2),
                                  Text(card.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 1. CLICKABLE SUGGESTED HOSPITALS SECTION (With Distance & Travel ETA)
                  if (message.suggestedHospitals != null && message.suggestedHospitals!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.local_hospital_rounded, size: 16, color: Color(0xFF0284C7)),
                        SizedBox(width: 6),
                        Text(
                          'Nearby Hospitals & Facilities',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...message.suggestedHospitals!.map((hosp) {
                      final int etaMins = (hosp.distanceKm * 3.5).round().clamp(3, 45);
                      final hospDocs = ProductionDatabase.doctors.where((d) => d.hospitalId == hosp.id).toList();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    hosp.logoUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 44,
                                      height: 44,
                                      color: const Color(0xFFE0F2FE),
                                      child: const Icon(Icons.local_hospital_rounded, color: Color(0xFF0284C7)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hosp.name,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        hosp.location,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.near_me_rounded, size: 10, color: Color(0xFF0284C7)),
                                                const SizedBox(width: 3),
                                                Text(
                                                  '${hosp.distanceKm.toStringAsFixed(1)} km',
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF059669).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.directions_car_rounded, size: 10, color: Color(0xFF059669)),
                                                const SizedBox(width: 3),
                                                Text(
                                                  'ETA: ~$etaMins mins',
                                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (hospDocs.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Divider(height: 12, color: Color(0xFFBAE6FD)),
                              Text(
                                'Available Specialists at ${hosp.name.split(" ").first}:',
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 4),
                              ...hospDocs.take(2).map((doc) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(doc.photoUrl),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${doc.name} • ${doc.specialty}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onBookDoctor(doc),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text('Book Slot', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => onViewHospital(hosp),
                                  icon: const Icon(Icons.apartment_rounded, size: 13),
                                  label: const Text('View Hospital & Doctors', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0284C7),
                                    side: const BorderSide(color: Color(0xFF0284C7), width: 1),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 2. CLICKABLE SUGGESTED MEDICINES SECTION
                  if (message.suggestedMedicines != null && message.suggestedMedicines!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.medication_rounded, size: 16, color: Color(0xFF0284C7)),
                        SizedBox(width: 6),
                        Text(
                          'Suggested Medications (Direct Order)',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...message.suggestedMedicines!.map((med) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.local_pharmacy_rounded, color: Color(0xFF0284C7), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(med.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text('${med.packSize} • ₹${med.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => onOrderMedicine(med),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Order 15-Min', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 3. CLICKABLE SUGGESTED DOCTORS SECTION
                  if (message.suggestedDoctors != null && message.suggestedDoctors!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        Icon(Icons.person_rounded, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Recommended Specialist Doctors',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...message.suggestedDoctors!.map((doc) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(doc.photoUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text('${doc.specialty} • ${doc.hospitalName}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text('Fee: ₹${doc.videoFee.toStringAsFixed(0)} • In-Clinic: ₹${doc.clinicFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => onBookDoctor(doc),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Book Consult', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 3. CLICKABLE SUGGESTED LAB TESTS SECTION
                  if (message.suggestedLabTests != null && message.suggestedLabTests!.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        Icon(Icons.biotech_rounded, size: 16, color: Color(0xFF0F766E)),
                        SizedBox(width: 6),
                        Text(
                          'Suggested Diagnostic Blood Panels',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...message.suggestedLabTests!.map((test) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.science_rounded, color: Color(0xFF0F766E), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(test.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text('${test.reportDeliveryTime} • ₹${test.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => onBookLabTest(test),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F766E),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Book Test', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  // 4. ACTION SUGGESTIONS IN A SINGLE HORIZONTALLY SCROLLABLE ROW
                  if (message.actionSuggestions != null && message.actionSuggestions!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: message.actionSuggestions!.map((sugg) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(sugg, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.primary, width: 0.8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              onPressed: () => onSuggestionTap(sugg),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Markdown Parser Widget that strips raw asterisks (**) and renders clean bold spans
class _MarkdownFormattedText extends StatelessWidget {
  final String text;
  const _MarkdownFormattedText({required this.text});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      // Parse bold **text** markers
      final parts = line.split('**');
      for (int j = 0; j < parts.length; j++) {
        final part = parts[j];
        if (part.isEmpty) continue;

        // Odd indices were enclosed in **
        if (j % 2 == 1) {
          spans.add(
            TextSpan(
              text: part,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 13.5),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: part,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5, height: 1.4),
            ),
          );
        }
      }

      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
