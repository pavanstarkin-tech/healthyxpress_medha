import 'dart:convert';
import 'package:http/http.dart' as http;

class SarvamAiResponse {
  final String content;
  final List<String> detectedSymptoms;
  final String triageCategory;
  final List<String> actionSuggestions;

  SarvamAiResponse({
    required this.content,
    required this.detectedSymptoms,
    required this.triageCategory,
    required this.actionSuggestions,
  });
}

class SarvamAiService {
  static const String _apiKey = 'sk_n4tzuy3c_JIUK6l5ExNHHGoiiAGwvroYh';
  static const String _model = 'sarvam-105b-conversations';
  static const String _endpoint = 'https://api.sarvam.ai/v1/chat/completions';

  static const String _systemPrompt = '''
You are HealthExpress AI, an intelligent, empathetic medical assistant for an Indian clinical healthcare platform.
Your responsibilities:
1. Provide accurate, clear, and reassuring triage for symptoms.
2. Recommend appropriate next steps (e.g. consulting a General Physician or specialist, booking specific lab tests, 15-minute emergency pharmacy delivery).
3. Always emphasize that you are an AI triage assistant and advise consulting a certified doctor for formal prescriptions.
4. Keep your response concise (3-4 paragraphs max) and formatted with clean bullet points.
''';

  /// Call Sarvam AI with user inquiry
  static Future<SarvamAiResponse> queryClinicalTriage({
    required String userQuery,
    String? patientName,
  }) async {
    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        {
          'role': 'user',
          'content': patientName != null
              ? 'Patient Name: $patientName. Query: $userQuery'
              : userQuery,
        }
      ];

      final res = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'api-subscription-key': _apiKey,
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.3,
          'max_tokens': 450,
        }),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data['choices']?[0]?['message']?['content']?.toString().trim() ?? '';
        
        final symptoms = _extractSymptoms(userQuery);
        final category = _categorizeQuery(userQuery);
        final actions = _generateActionSuggestions(category);

        return SarvamAiResponse(
          content: reply.isNotEmpty ? reply : _fallbackResponse(userQuery, category),
          detectedSymptoms: symptoms,
          triageCategory: category,
          actionSuggestions: actions,
        );
      } else {
        // Graceful fallback to clinical rules if Sarvam API returns rate-limit or error
        final category = _categorizeQuery(userQuery);
        return SarvamAiResponse(
          content: _fallbackResponse(userQuery, category),
          detectedSymptoms: _extractSymptoms(userQuery),
          triageCategory: category,
          actionSuggestions: _generateActionSuggestions(category),
        );
      }
    } catch (e) {
      final category = _categorizeQuery(userQuery);
      return SarvamAiResponse(
        content: _fallbackResponse(userQuery, category),
        detectedSymptoms: _extractSymptoms(userQuery),
        triageCategory: category,
        actionSuggestions: _generateActionSuggestions(category),
      );
    }
  }

  static List<String> _extractSymptoms(String text) {
    final lower = text.toLowerCase();
    final List<String> detected = [];
    if (lower.contains('fever') || lower.contains('temp')) detected.add('Fever');
    if (lower.contains('headache') || lower.contains('head')) detected.add('Headache');
    if (lower.contains('throat') || lower.contains('cough')) detected.add('Throat Irritation');
    if (lower.contains('chest') || lower.contains('breath')) detected.add('Chest / Respiratory');
    if (lower.contains('stomach') || lower.contains('vomit')) detected.add('Gastric Distress');
    if (lower.contains('joint') || lower.contains('knee')) detected.add('Joint Pain');
    if (lower.contains('sugar') || lower.contains('diabetes')) detected.add('Blood Glucose');
    if (lower.contains('bp') || lower.contains('pressure')) detected.add('Blood Pressure');
    if (detected.isEmpty) detected.add('General Symptom Evaluation');
    return detected;
  }

  static String _categorizeQuery(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('chest') || lower.contains('heart') || lower.contains('emergency') || lower.contains('breath')) {
      return 'Cardiac Alert / Emergency';
    }
    if (lower.contains('sugar') || lower.contains('diabetes') || lower.contains('glucose')) {
      return 'Diabetes & Metabolic Care';
    }
    if (lower.contains('bp') || lower.contains('pressure') || lower.contains('hypertension')) {
      return 'Cardiology & Hypertension';
    }
    if (lower.contains('joint') || lower.contains('knee') || lower.contains('back')) {
      return 'Orthopedic & Joint Mobility';
    }
    if (lower.contains('fever') || lower.contains('cold') || lower.contains('cough')) {
      return 'Viral Fever & Flu';
    }
    return 'General Health Inquiry';
  }

  static List<String> _generateActionSuggestions(String category) {
    switch (category) {
      case 'Cardiac Alert / Emergency':
        return ['🚨 Dispatch Ambulance Now', '📞 Call 108 Emergency', '🏥 View Nearest Emergency Hospitals'];
      case 'Diabetes & Metabolic Care':
        return ['🩸 Book HbA1c & Fasting Glucose', '👨‍⚕️ Consult Diabetologist', '📦 Order Continuous Glucose Sensor'];
      case 'Cardiology & Hypertension':
        return ['🩺 Consult Cardiologist', '📊 Book Lipid & Cardiac Profile', '📦 Order Digital BP Monitor'];
      case 'Orthopedic & Joint Mobility':
        return ['🦴 Consult Orthopedic Specialist', '🧪 Book Vitamin D & Calcium Panel', '📦 Order Knee Heat Wrap'];
      case 'Viral Fever & Flu':
        return ['💊 Order Medicines (15-Min Delivery)', '👨‍⚕️ Book Video Doctor Consult', '🩸 Book CBC Blood Test'];
      default:
        return ['👨‍⚕️ Book Doctor Consultation', '💊 Search Medicines', '🧪 Book Master Health Checkup'];
    }
  }

  static String _fallbackResponse(String userQuery, String category) {
    switch (category) {
      case 'Cardiac Alert / Emergency':
        return '⚠️ **EMERGENCY CLINICAL ALERT**: Symptoms involving chest pressure or shortness of breath require immediate medical evaluation. Please trigger Emergency SOS or call 108 immediately.';
      case 'Diabetes & Metabolic Care':
        return 'Based on your query regarding blood glucose, regular daily monitoring and quarterly HbA1c screening are advised. Avoid high glycemic foods and keep yourself hydrated.';
      case 'Cardiology & Hypertension':
        return 'Blood pressure fluctuations require daily telemetry logging. We recommend checking your BP at the same time daily, limiting dietary sodium, and scheduling a cardiology consult.';
      case 'Orthopedic & Joint Mobility':
        return 'Joint and musculoskeletal strain benefits from relative rest, warm compression, and avoiding sudden heavy loads. Consider an orthopedic review if swelling occurs.';
      case 'Viral Fever & Flu':
        return 'Your symptoms match an acute viral respiratory/fever episode. Adequate hydration, bed rest, and fever monitoring every 6 hours are recommended. Paracetamol 650mg can be taken for fever relief.';
      default:
        return 'I have evaluated your health inquiry. For optimal recovery and comprehensive care, our network of verified physicians and diagnostic partners is available for instant booking.';
    }
  }
}
