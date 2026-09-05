import 'package:flutter/material.dart';
import '../data/production_database.dart';
import '../models/doctor_model.dart';
import '../models/medicine_model.dart';
import '../models/lab_test_model.dart';
import '../models/business_product_model.dart';
import '../services/sarvam_ai_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isAudio;
  final List<String>? actionSuggestions;
  final List<String>? detectedSymptoms;
  final List<BusinessProductModel>? recommendedProducts;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isAudio = false,
    this.actionSuggestions,
    this.detectedSymptoms,
    this.recommendedProducts,
  });
}

class AiAssistantProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'msg-1',
      text: 'Hello! 👋 I am your HealthExpress AI Assistant powered by Sarvam AI. Tell me how you are feeling today or describe any symptoms.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      actionSuggestions: ['I have fever & body pain', 'High blood sugar & diabetes', 'Knee & joint pain', 'High blood pressure'],
    ),
  ];

  bool _isListening = false;
  bool _isThinking = false;
  bool _isSpeaking = false;
  String _activeDiagnosis = 'General Health Inquiry';
  String _userInterestSegment = 'Preventive Master Checkups';
  List<String> _currentSymptoms = [];

  List<ChatMessage> get messages => _messages;
  bool get isListening => _isListening;
  bool get isThinking => _isThinking;
  bool get isSpeaking => _isSpeaking;
  String get activeDiagnosis => _activeDiagnosis;
  String get userInterestSegment => _userInterestSegment;
  List<String> get currentSymptoms => _currentSymptoms;

  List<MedicineModel> get suggestedMedicines {
    if (_activeDiagnosis.contains('Fever') || _activeDiagnosis.contains('Viral')) {
      return ProductionDatabase.medicines.where((m) => m.id == 'MED-01' || m.id == 'MED-02' || m.id == 'MED-03' || m.id == 'MED-04' || m.id == 'MED-05').toList();
    }
    return ProductionDatabase.medicines.take(4).toList();
  }

  List<DoctorModel> get suggestedDoctors {
    if (_activeDiagnosis.contains('Fever') || _activeDiagnosis.contains('Viral')) {
      return ProductionDatabase.doctors.where((d) => d.specialty.contains('General') || d.isRmpDoctor).toList();
    }
    return ProductionDatabase.doctors.take(3).toList();
  }

  List<LabTestModel> get suggestedLabTests {
    return ProductionDatabase.labTests.where((t) => t.code == 'CBC' || t.code == 'NS1-ANTIGEN' || t.code == 'MAL-AG').toList();
  }

  List<BusinessProductModel> get suggestedBusinessProducts {
    if (_userInterestSegment.contains('Diabetes')) {
      return [ProductionDatabase.businessProducts[0], ProductionDatabase.businessProducts[1]];
    } else if (_userInterestSegment.contains('Cardiology') || _userInterestSegment.contains('Hypertension')) {
      return [ProductionDatabase.businessProducts[2], ProductionDatabase.businessProducts[3]];
    } else if (_userInterestSegment.contains('Orthopedic')) {
      return [ProductionDatabase.businessProducts[4], ProductionDatabase.businessProducts[3]];
    } else if (_userInterestSegment.contains('Women')) {
      return [ProductionDatabase.businessProducts[6], ProductionDatabase.businessProducts[3]];
    }
    return [ProductionDatabase.businessProducts[3], ProductionDatabase.businessProducts[5]];
  }

  void toggleVoiceListening() {
    _isListening = !_isListening;
    if (_isListening) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_isListening) {
          _isListening = false;
          addUserMessage('I have a severe headache and throat irritation since morning.');
        }
      });
    }
    notifyListeners();
  }

  Future<void> addUserMessage(String text, {String? patientName}) async {
    final userMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isThinking = true;
    notifyListeners();

    try {
      final aiRes = await SarvamAiService.queryClinicalTriage(
        userQuery: text,
        patientName: patientName,
      );

      _activeDiagnosis = aiRes.triageCategory;
      _userInterestSegment = aiRes.triageCategory;
      _currentSymptoms = aiRes.detectedSymptoms;

      final botMsg = ChatMessage(
        id: 'msg-bot-${DateTime.now().millisecondsSinceEpoch}',
        text: aiRes.content,
        isUser: false,
        timestamp: DateTime.now(),
        detectedSymptoms: aiRes.detectedSymptoms,
        actionSuggestions: aiRes.actionSuggestions,
        recommendedProducts: suggestedBusinessProducts,
      );

      _messages.add(botMsg);
    } catch (_) {
      _generateAiResponse(text);
    } finally {
      _isThinking = false;
      notifyListeners();
    }
  }

  void _generateAiResponse(String userInput) {
    final lower = userInput.toLowerCase();
    List<String> detected = [];
    String responseText = '';
    List<String> actions = [];
    List<BusinessProductModel> recommended = [];

    if (lower.contains('diabetes') || lower.contains('sugar') || lower.contains('glucose') || lower.contains('hba1c')) {
      _activeDiagnosis = 'Diabetes & Glycemic Care';
      _userInterestSegment = 'Diabetes & Metabolic Care';
      detected = ['High Blood Sugar', 'Frequent Thirst', 'Glycemic Fatigue'];
      responseText = 'I have identified indicators related to blood sugar management. Regular daily glucose monitoring and periodic HbA1c screening are critical to prevent neuropathy and renal complications.\n\nHealthExpress provides smart automated glucometer syncing with our doctors:';
      actions = ['Order Glucometer Kit', 'Book Diabetic Profile', 'Consult Diabetologist'];
      recommended = [ProductionDatabase.businessProducts[0], ProductionDatabase.businessProducts[1]];
    } else if (lower.contains('knee') || lower.contains('joint') || lower.contains('arthritis') || lower.contains('back pain') || lower.contains('bone')) {
      _activeDiagnosis = 'Joint Pain & Musculoskeletal Strain';
      _userInterestSegment = 'Orthopedic & Joint Mobility';
      detected = ['Joint Pain', 'Morning Stiffness', 'Reduced Mobility'];
      responseText = 'Musculoskeletal joint discomfort detected. We advise avoiding sudden high-impact strain, applying targeted infrared heat therapy, and consulting an orthopedic specialist if swelling persists.\n\nRecommended therapeutic care & diagnostic screening:';
      actions = ['Order Knee Heat Wrap', 'Consult Orthopedic', 'Book Bone Density Panel'];
      recommended = [ProductionDatabase.businessProducts[4], ProductionDatabase.businessProducts[3]];
    } else if (lower.contains('bp') || lower.contains('pressure') || lower.contains('hypertension') || lower.contains('palpitation')) {
      _activeDiagnosis = 'Hypertension & Cardiac Telemetry';
      _userInterestSegment = 'Cardiology & Hypertension';
      detected = ['Elevated BP', 'Dizziness', 'Pulse Fluctuations'];
      responseText = 'Blood pressure variations require systematic daily tracking. We recommend recording systolic/diastolic readings morning and evening, reducing sodium intake, and logging vitals in your HealthExpress Vault.';
      actions = ['Order Digital BP Kit', 'Consult Cardiologist', 'Book Cardiac Risk Panel'];
      recommended = [ProductionDatabase.businessProducts[2], ProductionDatabase.businessProducts[3]];
    } else if (lower.contains('fever') || lower.contains('temperature') || lower.contains('chills') || lower.contains('throat')) {
      _activeDiagnosis = 'Viral Fever & Flu';
      _userInterestSegment = 'Preventive Master Checkups';
      detected = ['Fever', 'Body Pain', 'Sore Throat'];
      responseText = 'I have analyzed your symptoms. It matches acute viral fever. I recommend adequate hydration, resting, monitoring temperature 3 times a day, and taking Paracetamol 650mg if temperature rises above 99.5°F.';
      actions = ['View Suggested Medicines', 'Book Doctor Visit', 'Book CBC Blood Test'];
      recommended = [ProductionDatabase.businessProducts[3], ProductionDatabase.businessProducts[5]];
    } else if (lower.contains('chest') || lower.contains('breath') || lower.contains('heart') || lower.contains('emergency')) {
      _activeDiagnosis = 'Cardiac Alert / Emergency';
      _userInterestSegment = 'Cardiology & Hypertension';
      detected = ['Chest Discomfort', 'Shortness of Breath'];
      responseText = '⚠️ IMPORTANT: Chest symptoms require immediate clinical evaluation. Please tap Emergency SOS below to dispatch an ambulance or call 108 immediately.';
      actions = ['Dispatch Ambulance Now', 'Call 108 SOS', 'Nearby Cardiac Hospitals'];
      recommended = []; // Strictly suppressed in emergency
    } else {
      _activeDiagnosis = 'General Health Inquiry';
      _userInterestSegment = 'Preventive Master Checkups';
      detected = ['Wellness Check'];
      responseText = 'Thank you for sharing. I am keeping track of your health profile. Would you like to explore nearby hospitals, specialist doctors, or our comprehensive family care passes?';
      actions = ['Find Doctors', 'Nearby Hospitals', 'Order Medicines'];
      recommended = [ProductionDatabase.businessProducts[3], ProductionDatabase.businessProducts[5]];
    }

    _currentSymptoms = detected;

    final aiMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      detectedSymptoms: detected,
      actionSuggestions: actions,
      recommendedProducts: recommended.isNotEmpty ? recommended : null,
    );
    _messages.add(aiMsg);
  }

  void selectCondition(String condition) {
    _activeDiagnosis = condition;
    if (condition == 'Fever') {
      _currentSymptoms = ['Fever', 'Cough', 'Headache'];
      _userInterestSegment = 'Preventive Master Checkups';
    } else if (condition == 'Cold & Cough') {
      _currentSymptoms = ['Cough', 'Sore Throat', 'Runny Nose'];
      _userInterestSegment = 'Preventive Master Checkups';
    } else if (condition == 'Diabetes') {
      _currentSymptoms = ['High Sugar', 'Frequent Thirst', 'Fatigue'];
      _userInterestSegment = 'Diabetes & Metabolic Care';
    } else if (condition == 'Migraine') {
      _currentSymptoms = ['Headache', 'Sensitivity', 'Fatigue'];
      _userInterestSegment = 'Preventive Master Checkups';
    }
    notifyListeners();
  }
}
