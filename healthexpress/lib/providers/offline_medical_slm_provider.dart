import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/offline_medical_models.dart';
import '../data/validated_first_aid_protocols.dart';
import '../services/medical_slm_engine_service.dart';
import '../services/model_download_service.dart';
import '../services/model_storage_service.dart';
import '../services/offline_voice_service.dart';

/// Central Provider coordinating the on-device Medical SLM,
/// offline AI Doctor Avatar, first-aid protocols, and voice engine.
class OfflineMedicalSlmProvider extends ChangeNotifier {
  final MedicalSlmEngineService _engineService = MedicalSlmEngineService();
  final ModelDownloadService _downloadService = ModelDownloadService();
  final OfflineVoiceService _voiceService = OfflineVoiceService();
  final Uuid _uuid = const Uuid();

  List<GgufModel> _catalogModels = [];
  GgufModel? _activeModel;
  bool _isLoadingCatalog = false;

  final List<OfflineDoctorMessage> _messages = [];
  DoctorAvatarState _avatarState = DoctorAvatarState.idle;
  FirstAidProtocol? _activeProtocol;
  int _activeProtocolStepIndex = 0;

  // CPR Metronome State
  bool _isCprMetronomeActive = false;
  int _cprCompressionCount = 0;
  int _cprCycleCount = 0;
  Timer? _cprMetronomeTimer;

  // Voice State
  bool _autoVoiceReadout = true;
  String _selectedLanguage = 'en'; // 'en', 'hi', 'te'

  MedicalSlmEngineService get engine => _engineService;
  ModelDownloadService get downloadService => _downloadService;
  OfflineVoiceService get voiceService => _voiceService;
  List<GgufModel> get catalogModels => List.unmodifiable(_catalogModels);
  GgufModel? get activeModel => _activeModel;
  bool get isLoadingCatalog => _isLoadingCatalog;
  List<OfflineDoctorMessage> get messages => List.unmodifiable(_messages);
  DoctorAvatarState get avatarState => _avatarState;
  FirstAidProtocol? get activeProtocol => _activeProtocol;
  int get activeProtocolStepIndex => _activeProtocolStepIndex;
  bool get isCprMetronomeActive => _isCprMetronomeActive;
  int get cprCompressionCount => _cprCompressionCount;
  int get cprCycleCount => _cprCycleCount;
  bool get autoVoiceReadout => _autoVoiceReadout;
  String get selectedLanguage => _selectedLanguage;

  OfflineMedicalSlmProvider() {
    _initProvider();
  }

  Future<void> _initProvider() async {
    await loadCatalogModels();
    _initWelcomeDoctorMessage();

    // Listen to voice service changes for avatar speech animation
    _voiceService.addListener(() {
      if (_voiceService.isSpeaking && _avatarState != DoctorAvatarState.speaking) {
        _avatarState = DoctorAvatarState.speaking;
        notifyListeners();
      } else if (_voiceService.isListening && _avatarState != DoctorAvatarState.listening) {
        _avatarState = DoctorAvatarState.listening;
        notifyListeners();
      } else if (!_voiceService.isSpeaking && !_voiceService.isListening && _avatarState == DoctorAvatarState.speaking) {
        _avatarState = _activeProtocol != null ? DoctorAvatarState.emergency : DoctorAvatarState.idle;
        notifyListeners();
      }
    });

    // Listen to engine state
    _engineService.addListener(() {
      if (_engineService.isGenerating && _avatarState != DoctorAvatarState.thinking && _avatarState != DoctorAvatarState.speaking) {
        _avatarState = DoctorAvatarState.thinking;
        notifyListeners();
      }
    });
  }

  void _initWelcomeDoctorMessage() {
    _messages.clear();
    _messages.add(
      OfflineDoctorMessage(
        id: _uuid.v4(),
        role: 'assistant',
        text: 'Hello, I am Dr. Medha — your offline Medical Small Language Model (SLM) & Clinical First-Aid Specialist. '
            'I work 100% locally on your device with zero internet required. '
            'How can I help you today? You can ask about symptoms, or choose an emergency protocol below.',
        timestamp: DateTime.now(),
        actionPrompts: [
          'Adult CPR Guide',
          'Choking Heimlich Maneuver',
          'Severe Bleeding Control',
          'Burn Treatment Protocol',
          'Snake Bite Emergency',
          'Chest Pain & Heart Attack',
        ],
      ),
    );
  }

  /// Load catalog models from assets and reconcile with on-device files.
  Future<void> loadCatalogModels() async {
    _isLoadingCatalog = true;
    notifyListeners();

    try {
      final jsonStr = await rootBundle.loadString('assets/models.json');
      final data = jsonDecode(jsonStr);
      final rawList = (data['models'] as List<dynamic>?) ?? [];

      final models = rawList.map((m) => GgufModel.fromJson(m as Map<String, dynamic>)).toList();

      for (final m in models) {
        await ModelStorageService.reconcileModelState(m);
      }

      _catalogModels = models;

      // Select active model
      final savedId = await ModelStorageService.getActiveModelId();
      if (savedId != null) {
        _activeModel = _catalogModels.firstWhere(
          (m) => m.id == savedId,
          orElse: () => _catalogModels.first,
        );
        final onDisk = _catalogModels.where((m) => m.isOnDisk).toList();
        if (onDisk.isNotEmpty) {
          _activeModel = onDisk.first;
        } else if (_catalogModels.isNotEmpty) {
          _activeModel = _catalogModels.first;
        } else {
          _activeModel = null;
        }
      }
    } catch (e) {
      debugPrint('[OfflineMedicalSlmProvider] loadCatalogModels error: $e');
    } finally {
      _isLoadingCatalog = false;
      notifyListeners();
    }
  }

  /// Start model download.
  Future<void> downloadModel(GgufModel model) async {
    await _downloadService.start(
      model: model,
      onProgress: (m) => notifyListeners(),
      onComplete: (m, path) async {
        await ModelStorageService.setActiveModelId(m.id);
        _activeModel = m;
        notifyListeners();
        // Automatically load into engine
        await loadModelIntoEngine(m);
      },
      onError: (m, err) {
        debugPrint('[Download Error] $err');
        notifyListeners();
      },
    );
    notifyListeners();
  }

  /// Load model into LlamaEngine.
  Future<void> loadModelIntoEngine(GgufModel model) async {
    if (!model.isOnDisk || model.localPath == null) return;
    try {
      _avatarState = DoctorAvatarState.thinking;
      notifyListeners();
      await _engineService.loadModel(model.localPath!, promptFormat: model.promptFormat);
      _activeModel = model;
      await ModelStorageService.setActiveModelId(model.id);
      _avatarState = DoctorAvatarState.idle;
      notifyListeners();
    } catch (e) {
      _avatarState = DoctorAvatarState.idle;
      notifyListeners();
    }
  }

  /// Send message to the Medical SLM.
  Future<void> sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    // Check if query triggers a validated emergency protocol
    final matchedProtocol = ValidatedFirstAidProtocols.findProtocolForQuery(query);
    if (matchedProtocol != null && _activeProtocol == null) {
      _activeProtocol = matchedProtocol;
      _activeProtocolStepIndex = 0;
      _avatarState = DoctorAvatarState.emergency;
    }

    final userMsg = OfflineDoctorMessage(
      id: _uuid.v4(),
      role: 'user',
      text: query,
      timestamp: DateTime.now(),
      associatedProtocol: _activeProtocol,
    );
    _messages.add(userMsg);

    final assistantMsgId = _uuid.v4();
    final assistantMsg = OfflineDoctorMessage(
      id: assistantMsgId,
      role: 'assistant',
      text: '',
      timestamp: DateTime.now(),
      isStreaming: true,
      associatedProtocol: _activeProtocol,
      triageLevel: _activeProtocol?.emergencyLevel,
    );
    _messages.add(assistantMsg);
    _avatarState = DoctorAvatarState.thinking;
    notifyListeners();

    final buffer = StringBuffer();

    try {
      final metrics = await _engineService.generateMedicalResponse(
        userQuery: query,
        activeProtocol: _activeProtocol,
        onToken: (token) {
          buffer.write(token);
          final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
          if (idx != -1) {
            _messages[idx] = _messages[idx].copyWith(
              text: buffer.toString(),
              isStreaming: true,
            );
            notifyListeners();
          }
        },
        onComplete: (fullText) {
          final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
          if (idx != -1) {
            _messages[idx] = _messages[idx].copyWith(
              text: fullText,
              isStreaming: false,
            );
            notifyListeners();
          }

          if (_autoVoiceReadout) {
            _voiceService.speak(fullText);
          } else {
            _avatarState = _activeProtocol != null ? DoctorAvatarState.emergency : DoctorAvatarState.idle;
            notifyListeners();
          }
        },
        onError: (err) {
          final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
          if (idx != -1) {
            _messages[idx] = _messages[idx].copyWith(
              text: '⚠️ An error occurred during offline generation: $err',
              isStreaming: false,
            );
            _avatarState = DoctorAvatarState.idle;
            notifyListeners();
          }
        },
      );

      final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(metrics: metrics);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[OfflineMedicalSlmProvider] sendMessage error: $e');
    }
  }

  /// Launch a specific validated first-aid protocol directly.
  void launchFirstAidProtocol(FirstAidProtocol protocol) {
    _activeProtocol = protocol;
    _activeProtocolStepIndex = 0;
    _avatarState = DoctorAvatarState.emergency;
    notifyListeners();

    final promptText = 'Emergency protocol requested: ${protocol.title}. Please provide rapid first-aid steps.';
    sendMessage(promptText);

    // Speak initial step audio if available
    if (protocol.steps.isNotEmpty && protocol.steps.first.audioInstruction != null && _autoVoiceReadout) {
      _voiceService.speak(protocol.steps.first.audioInstruction!);
    }
  }

  /// Next step in active protocol.
  void nextProtocolStep() {
    if (_activeProtocol == null) return;
    if (_activeProtocolStepIndex < _activeProtocol!.steps.length - 1) {
      _activeProtocolStepIndex++;
      final step = _activeProtocol!.steps[_activeProtocolStepIndex];
      if (step.audioInstruction != null && _autoVoiceReadout) {
        _voiceService.speak(step.audioInstruction!);
      }
      notifyListeners();
    }
  }

  /// Previous step in active protocol.
  void previousProtocolStep() {
    if (_activeProtocol == null) return;
    if (_activeProtocolStepIndex > 0) {
      _activeProtocolStepIndex--;
      notifyListeners();
    }
  }

  /// Close active protocol overlay.
  void closeActiveProtocol() {
    _activeProtocol = null;
    _activeProtocolStepIndex = 0;
    stopCprMetronome();
    _avatarState = DoctorAvatarState.idle;
    notifyListeners();
  }

  /// Start 110 BPM CPR compression audio & visual metronome.
  void startCprMetronome() {
    _isCprMetronomeActive = true;
    _cprCompressionCount = 0;
    _cprCycleCount = 0;
    _avatarState = DoctorAvatarState.emergency;
    notifyListeners();

    // 110 beats per minute = 1 beat every ~545 milliseconds
    const beatInterval = Duration(milliseconds: 545);
    _cprMetronomeTimer?.cancel();
    _cprMetronomeTimer = Timer.periodic(beatInterval, (timer) {
      _cprCompressionCount++;

      // Haptic feedback tick
      HapticFeedback.lightImpact();

      if (_cprCompressionCount >= 30) {
        _cprCompressionCount = 0;
        _cprCycleCount++;
        // Cycle prompt: 2 rescue breaths or continue hands-only
        if (_autoVoiceReadout) {
          _voiceService.speak('Cycle $_cprCycleCount complete. Deliver two breaths or continue continuous compressions.');
        }
      }
      notifyListeners();
    });
  }

  /// Stop CPR metronome.
  void stopCprMetronome() {
    _isCprMetronomeActive = false;
    _cprMetronomeTimer?.cancel();
    _cprMetronomeTimer = null;
    _cprCompressionCount = 0;
    notifyListeners();
  }

  /// Toggle speech recognition listening.
  Future<void> toggleVoiceInput() async {
    if (_voiceService.isListening) {
      await _voiceService.stopListening();
      _avatarState = DoctorAvatarState.idle;
      notifyListeners();
    } else {
      _avatarState = DoctorAvatarState.listening;
      notifyListeners();
      await _voiceService.startListening(
        onResult: (words) {},
        onFinalResult: (finalWords) {
          if (finalWords.trim().isNotEmpty) {
            sendMessage(finalWords);
          }
        },
      );
    }
  }

  /// Toggle language (English, Telugu, Hindi).
  Future<void> setLanguage(String langCode) async {
    _selectedLanguage = langCode;
    await _voiceService.setLanguage(langCode);
    notifyListeners();
  }

  void toggleAutoVoiceReadout(bool value) {
    _autoVoiceReadout = value;
    notifyListeners();
  }

  void stopSpeaking() {
    _voiceService.stopSpeaking();
    _avatarState = _activeProtocol != null ? DoctorAvatarState.emergency : DoctorAvatarState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _cprMetronomeTimer?.cancel();
    _engineService.dispose();
    _voiceService.dispose();
    super.dispose();
  }
}
