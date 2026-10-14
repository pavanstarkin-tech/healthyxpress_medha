import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/validated_first_aid_protocols.dart';
import '../../models/offline_medical_models.dart';
import '../../providers/offline_medical_slm_provider.dart';
import '../../widgets/first_aid_interactive_card.dart';
import '../../widgets/offline_doctor_avatar_widget.dart';
import '../../widgets/offline_model_manager_sheet.dart';

/// Flagship Screen for Offline Medical Small Language Model (SLM)
/// & Offline-Capable AI Doctor Avatar (Dr. Medha).
/// Operates 100% locally on-device with zero internet connectivity required.
class OfflineAiDoctorScreen extends StatefulWidget {
  final FirstAidProtocol? initialProtocol;

  const OfflineAiDoctorScreen({super.key, this.initialProtocol});

  @override
  State<OfflineAiDoctorScreen> createState() => _OfflineAiDoctorScreenState();
}

class _OfflineAiDoctorScreenState extends State<OfflineAiDoctorScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialProtocol != null && mounted) {
        context.read<OfflineMedicalSlmProvider>().launchFirstAidProtocol(widget.initialProtocol!);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(OfflineMedicalSlmProvider provider) {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    provider.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfflineMedicalSlmProvider>(
      builder: (context, provider, _) {
        final activeModel = provider.activeModel;
        final isModelLoaded = provider.engine.isModelLoaded;
        final isGenerating = provider.engine.isGenerating;

        return Scaffold(
          backgroundColor: const Color(0xFF070B14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B132B),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E60F6).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.healing_rounded, color: Color(0xFF38BDF8), size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dr. Medha • Offline SLM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              isModelLoaded
                                  ? (activeModel?.name ?? 'Local Model Loaded')
                                  : 'On-Device Clinical Protocol Engine',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 10.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Language Selector
              PopupMenuButton<String>(
                icon: const Icon(Icons.translate_rounded, color: Colors.white70, size: 20),
                tooltip: 'Select Language',
                color: const Color(0xFF1E293B),
                onSelected: (lang) => provider.setLanguage(lang),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Text('English', style: TextStyle(color: provider.selectedLanguage == 'en' ? const Color(0xFF38BDF8) : Colors.white)),
                  ),
                  PopupMenuItem(
                    value: 'te',
                    child: Text('తెలుగు (Telugu)', style: TextStyle(color: provider.selectedLanguage == 'te' ? const Color(0xFF38BDF8) : Colors.white)),
                  ),
                  PopupMenuItem(
                    value: 'hi',
                    child: Text('हिन्दी (Hindi)', style: TextStyle(color: provider.selectedLanguage == 'hi' ? const Color(0xFF38BDF8) : Colors.white)),
                  ),
                ],
              ),
              // Model Manager Button
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: Color(0xFF38BDF8), size: 22),
                tooltip: 'Manage On-Device Models',
                onPressed: () => OfflineModelManagerSheet.show(context),
              ),
            ],
          ),
          body: Column(
            children: [
              // Doctor Avatar Hero Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0B132B),
                      Color(0xFF070B14),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    OfflineDoctorAvatarWidget(
                      state: provider.avatarState,
                      soundLevel: provider.voiceService.soundLevel,
                      isSpeaking: provider.voiceService.isSpeaking,
                      size: 115,
                      onAvatarTap: () {
                        if (provider.voiceService.isSpeaking) {
                          provider.stopSpeaking();
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    // Zero Internet Badge & Voice Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.wifi_off_rounded, color: Color(0xFF10B981), size: 13),
                              const SizedBox(width: 4),
                              Text(
                                'ZERO INTERNET • 100% PRIVATE',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => provider.toggleAutoVoiceReadout(!provider.autoVoiceReadout),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: provider.autoVoiceReadout
                                  ? const Color(0xFF38BDF8).withOpacity(0.2)
                                  : Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: provider.autoVoiceReadout ? const Color(0xFF38BDF8) : Colors.white12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  provider.autoVoiceReadout ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                                  color: provider.autoVoiceReadout ? const Color(0xFF38BDF8) : Colors.white60,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  provider.autoVoiceReadout ? 'VOICE ON' : 'MUTED',
                                  style: TextStyle(
                                    color: provider.autoVoiceReadout ? const Color(0xFF38BDF8) : Colors.white60,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Validated First-Aid Quick Action Carousel
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'CPR (110 BPM)',
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFFEF4444),
                      protocolId: 'cpr_cardiac_arrest',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Choking (Heimlich)',
                      icon: Icons.air_rounded,
                      color: const Color(0xFFF97316),
                      protocolId: 'choking_heimlich',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Severe Bleeding',
                      icon: Icons.water_drop_rounded,
                      color: const Color(0xFFDC2626),
                      protocolId: 'severe_bleeding',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Burns & Scalds',
                      icon: Icons.local_fire_department_rounded,
                      color: const Color(0xFFEAB308),
                      protocolId: 'burns_and_scalds',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Snake Bite',
                      icon: Icons.pest_control_rounded,
                      color: const Color(0xFF10B981),
                      protocolId: 'snake_bite',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Heart Attack',
                      icon: Icons.monitor_heart_rounded,
                      color: const Color(0xFFEF4444),
                      protocolId: 'heart_attack_chest_pain',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Seizures',
                      icon: Icons.bolt_rounded,
                      color: const Color(0xFF8B5CF6),
                      protocolId: 'seizure_epilepsy',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Fracture Splint',
                      icon: Icons.broken_image_rounded,
                      color: const Color(0xFF38BDF8),
                      protocolId: 'bone_fracture_sprain',
                    ),
                    _buildProtocolChip(
                      context,
                      provider,
                      title: 'Asthma Attack',
                      icon: Icons.air_rounded,
                      color: const Color(0xFF06B6D4),
                      protocolId: 'asthma_attack',
                    ),
                  ],
                ),
              ),

              // Active First-Aid Guided Step Card Overlay
              if (provider.activeProtocol != null)
                FirstAidInteractiveCard(
                  protocol: provider.activeProtocol!,
                  currentStepIndex: provider.activeProtocolStepIndex,
                  onNext: () => provider.nextProtocolStep(),
                  onPrevious: () => provider.previousProtocolStep(),
                  onClose: () => provider.closeActiveProtocol(),
                ),

              // Conversation Messages Stream
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    return _buildMessageBubble(context, provider, msg);
                  },
                ),
              ),

              // Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Voice Mic Button
                      GestureDetector(
                        onTap: () => provider.toggleVoiceInput(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: provider.voiceService.isListening
                                ? const Color(0xFF10B981)
                                : const Color(0xFF1E293B),
                            shape: BoxShape.circle,
                            boxShadow: provider.voiceService.isListening
                                ? [const BoxShadow(color: Color(0xFF10B981), blurRadius: 12, spreadRadius: 2)]
                                : null,
                          ),
                          child: Icon(
                            provider.voiceService.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Text Field
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: provider.voiceService.isListening
                                ? 'Listening to voice...'
                                : 'Describe symptoms or ask first-aid...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _handleSend(provider),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Send / Stop Button
                      if (isGenerating)
                        IconButton(
                          icon: const Icon(Icons.stop_circle_rounded, color: Color(0xFFEF4444), size: 30),
                          onPressed: () => provider.engine.stopGeneration(),
                          tooltip: 'Stop generation',
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: Color(0xFF38BDF8), size: 24),
                          onPressed: () => _handleSend(provider),
                          tooltip: 'Send message',
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProtocolChip(
    BuildContext context,
    OfflineMedicalSlmProvider provider, {
    required String title,
    required IconData icon,
    required Color color,
    required String protocolId,
  }) {
    final isSelected = provider.activeProtocol?.id == protocolId;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, color: isSelected ? Colors.white : color, size: 16),
        label: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isSelected ? color : const Color(0xFF1E293B),
        side: BorderSide(color: isSelected ? color : Colors.white12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          final p = ValidatedFirstAidProtocols.protocols.firstWhere(
            (p) => p.id == protocolId,
            orElse: () => ValidatedFirstAidProtocols.protocols.first,
          );
          provider.launchFirstAidProtocol(p);
          _scrollToBottom();
        },
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    OfflineMedicalSlmProvider provider,
    OfflineDoctorMessage msg,
  ) {
    final isUser = msg.role == 'user';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8, top: 2),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E60F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 14),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF1E60F6) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isUser ? Colors.transparent : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role Label
                      if (!isUser)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dr. Medha (Medical SLM)',
                              style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!msg.isStreaming && msg.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => provider.voiceService.speak(msg.text),
                                child: const Icon(Icons.volume_up_rounded, color: Colors.white70, size: 16),
                              ),
                          ],
                        ),
                      if (!isUser) const SizedBox(height: 6),

                      // Text Content
                      Text(
                        msg.text.isEmpty && msg.isStreaming ? 'Thinking...' : msg.text,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),

                      // Streaming indicator
                      if (msg.isStreaming) ...[
                        const SizedBox(height: 6),
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Color(0xFF38BDF8)),
                          ),
                        ),
                      ],

                      // Inference Performance Metrics
                      if (msg.metrics != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '⚡ ${msg.metrics!.tpsLabel} • TTFT: ${msg.metrics!.ttftLabel} • ${msg.metrics!.totalTimeLabel}',
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Action Prompts Suggestions
          if (msg.actionPrompts != null && msg.actionPrompts!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: msg.actionPrompts!.map((prompt) {
                return ActionChip(
                  label: Text(
                    prompt,
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color(0xFF1E293B),
                  side: const BorderSide(color: Color(0xFF38BDF8), width: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    provider.sendMessage(prompt);
                    _scrollToBottom();
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
