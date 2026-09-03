import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/appointment_model.dart';
import 'video_consultation_screen.dart';
import 'audio_call_screen.dart';

class ChatScreen extends StatefulWidget {
  final AppointmentModel appointment;
  const ChatScreen({super.key, required this.appointment});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isDoctor': true,
      'text': 'Hello Rahul! I have received your appointment request and reviewed your medical history. How can I help you today?',
      'time': '10:00 AM',
    },
    {
      'isDoctor': false,
      'text': 'Good morning Doctor. I have had low grade fever (99.8°F) and throat pain since yesterday.',
      'time': '10:02 AM',
    },
    {
      'isDoctor': true,
      'text': 'Understood. Please keep yourself hydrated with warm water and take Paracetamol 650mg after lunch. I will join our video consultation at the scheduled time to examine you.',
      'time': '10:05 AM',
    },
  ];

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'isDoctor': false,
        'text': text,
        'time': 'Just now',
      });
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'isDoctor': true,
          'text': 'Thank you for updating. I have added this to your clinical notes.',
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.appointment.doctorPhoto),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.appointment.doctorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const Text('Online • Available for consultation', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AudioCallScreen(appointment: widget.appointment)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => VideoConsultationScreen(appointment: widget.appointment)));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Secure Aarogyasri Encrypted Badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: const Color(0xFFEFF6FF),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 12, color: AppColors.primary),
                SizedBox(width: 6),
                Text('End-to-End Encrypted Consultation Channel', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isDoctor = msg['isDoctor'] as bool;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isDoctor ? MainAxisAlignment.start : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isDoctor) ...[
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(widget.appointment.doctorPhoto),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDoctor ? Colors.white : AppColors.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isDoctor ? 2 : 16),
                              bottomRight: Radius.circular(isDoctor ? 16 : 2),
                            ),
                            border: isDoctor ? Border.all(color: AppColors.border) : null,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isDoctor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['text'] as String,
                                style: TextStyle(color: isDoctor ? AppColors.textPrimary : Colors.white, fontSize: 14, height: 1.3),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] as String,
                                style: TextStyle(color: isDoctor ? AppColors.textMuted : Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textMuted),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attached Aarogyasri Health Records & Lab Reports')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
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
