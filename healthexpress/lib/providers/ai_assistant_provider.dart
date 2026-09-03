import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/doctor_model.dart';
import '../models/medicine_model.dart';
import '../models/lab_test_model.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isAudio;
  final List<String>? actionSuggestions;
  final List<String>? detectedSymptoms;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isAudio = false,
    this.actionSuggestions,
    this.detectedSymptoms,
  });
}

class AiAssistantProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'msg-1',
      text: 'Hello Rahul! 👋 I am your HealthExpress AI Assistant. Tell me how you are feeling today or describe any symptoms.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      actionSuggestions: ['I have fever & body pain', 'Headache & migraine', 'Sore throat & cough', 'Book an ambulance'],
    ),
    ChatMessage(
      id: 'msg-2',
      text: 'I have low grade fever, mild headache, and sore throat since yesterday morning.',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      id: 'msg-3',
      text: 'I understand. Based on your symptoms of low-grade fever, sore throat, and headache, it appears to be a mild Viral Upper Respiratory Infection.\n\nHere are clinical insights and tailored recommendations:',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      detectedSymptoms: ['Fever', 'Sore Throat', 'Headache'],
      actionSuggestions: ['View Medicines', 'Consult Doctor', 'Book CBC Test', 'Home Care Plan'],
    ),
  ];

  bool _isListening = false;
  bool _isThinking = false;
  bool _isSpeaking = false;
  String _activeDiagnosis = 'Viral Fever';
  List<String> _currentSymptoms = ['Fever', 'Sore Throat', 'Headache'];

  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isThinking => _isThinking;
  bool get isSpeaking => _isSpeaking;
  String get activeDiagnosis => _activeDiagnosis;
  List<String> get currentSymptoms => _currentSymptoms;

  List<MedicineModel> get suggestedMedicines {
    if (_activeDiagnosis.contains('Fever') || _activeDiagnosis.contains('Viral')) {
      return MockDatabase.medicines.where((m) => m.id == 'MED-01' || m.id == 'MED-02' || m.id == 'MED-03' || m.id == 'MED-04' || m.id == 'MED-05').toList();
    }
    return MockDatabase.medicines.take(4).toList();
  }

  List<DoctorModel> get suggestedDoctors {
    if (_activeDiagnosis.contains('Fever') || _activeDiagnosis.contains('Viral')) {
      return MockDatabase.doctors.where((d) => d.specialty.contains('General') || d.isRmpDoctor).toList();
    }
    return MockDatabase.doctors.take(3).toList();
  }

  List<LabTestModel> get suggestedLabTests {
    return MockDatabase.labTests.where((t) => t.code == 'CBC' || t.code == 'NS1-ANTIGEN' || t.code == 'MAL-AG').toList();
  }

  void toggleVoiceListening() {
    _isListening = !_isListening;
    if (_isListening) {
      // Simulate live voice recognition
      Future.delayed(const Duration(seconds: 3), () {
        if (_isListening) {
          _isListening = false;
          addUserMessage('I have a severe headache and throat irritation since morning.');
        }
      });
    }
    notifyListeners();
  }

  void addUserMessage(String text) {
    final userMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isThinking = true;
    notifyListeners();

    // Process diagnosis & AI response
    Future.delayed(const Duration(milliseconds: 1200), () {
      _isThinking = false;
      _generateAiResponse(text);
      notifyListeners();
    });
  }

  void _generateAiResponse(String userInput) {
    final lower = userInput.toLowerCase();
    List<String> detected = [];
    String responseText = '';
    List<String> actions = [];

    if (lower.contains('fever') || lower.contains('temperature') || lower.contains('chills')) {
      _activeDiagnosis = 'Viral Fever & Flu';
      detected = ['Fever', 'Body Pain', 'Sore Throat'];
      responseText = 'I have analyzed your symptoms. It matches acute viral fever. I recommend adequate hydration, resting, monitoring temperature 3 times a day, and taking Paracetamol 650mg if temperature rises above 99.5°F. You can also consult Dr. Ramesh Patel or book an RMP doctor for a home visit.';
      actions = ['View Suggested Medicines', 'Book Doctor Visit', 'Book CBC Blood Test'];
    } else if (lower.contains('headache') || lower.contains('migraine')) {
      _activeDiagnosis = 'Tension Headache / Migraine';
      detected = ['Headache', 'Eye Strain', 'Stress'];
      responseText = 'Headache symptoms detected. Please ensure you are in a quiet, dark room and stay hydrated. If nausea or light sensitivity occurs, consult a neurologist or general physician.';
      actions = ['Neurologist Consult', 'Pain Relief Medicine', 'Rest & Hydration'];
    } else if (lower.contains('chest') || lower.contains('breath') || lower.contains('heart') || lower.contains('emergency')) {
      _activeDiagnosis = 'Cardiac Alert / Emergency';
      detected = ['Chest Discomfort', 'Shortness of Breath'];
      responseText = '⚠️ IMPORTANT: Chest symptoms require immediate clinical evaluation. Please tap Emergency SOS below to dispatch an ambulance or call 108 immediately.';
      actions = ['Dispatch Ambulance Now', 'Call 108 SOS', 'Nearby Cardiac Hospitals'];
    } else {
      _activeDiagnosis = 'General Health Inquiry';
      detected = ['Wellness Check'];
      responseText = 'Thank you for sharing. I am keeping track of your health profile. Would you like to explore nearby hospitals, specialist doctors, or order prescription medicines?';
      actions = ['Find Doctors', 'Nearby Hospitals', 'Order Medicines'];
    }

    _currentSymptoms = detected;

    final aiMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      detectedSymptoms: detected,
      actionSuggestions: actions,
    );
    _messages.add(aiMsg);
  }

  void selectCondition(String condition) {
    _activeDiagnosis = condition;
    if (condition == 'Fever') {
      _currentSymptoms = ['Fever', 'Cough', 'Headache'];
    } else if (condition == 'Cold & Cough') {
      _currentSymptoms = ['Cough', 'Sore Throat', 'Runny Nose'];
    } else if (condition == 'Migraine') {
      _currentSymptoms = ['Headache', 'Sensitivity', 'Fatigue'];
    }
    notifyListeners();
  }
}
