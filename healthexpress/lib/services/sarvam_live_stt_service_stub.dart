class SarvamLiveSttService {
  static bool get isRecording => false;
  static bool get isLiveKitActive => false;

  static bool isSilenceCutoffTriggered() => false;
  static bool isSpeechJustEnded() => false;

  static Future<bool> startLiveKitVoiceSession({
    String? roomName,
    String? participantName,
  }) async => false;

  static Future<bool> stopLiveKitVoiceSession() async => true;

  static Future<bool> startListening(String langCode) async => false;

  static Future<String?> stopAndTranscribe(String langCode) async => null;

  static void speakText(String text, String langCode) {}

  static void stopSpeaking() {}

  static bool isSpeakingNow() => false;

  static String getLiveInterim() => '';
}
