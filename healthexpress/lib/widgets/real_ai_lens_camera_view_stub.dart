import 'package:flutter/material.dart';

typedef OnSnapshotCapturedCallback = void Function(String base64DataUri);

class RealAiLensCameraView extends StatefulWidget {
  final VoidCallback? onCameraReady;
  final Function(String error)? onCameraError;
  final Widget? overlayWidget;

  const RealAiLensCameraView({
    super.key,
    this.onCameraReady,
    this.onCameraError,
    this.overlayWidget,
  });

  @override
  State<RealAiLensCameraView> createState() => RealAiLensCameraViewState();
}

class RealAiLensCameraViewState extends State<RealAiLensCameraView> {
  bool get isStreaming => false;
  String get facingMode => 'environment';

  Future<void> startCamera() async {}
  Future<String?> captureFrame() async => null;
  Future<void> switchCamera() async {}
  void stopCamera() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 48),
            const SizedBox(height: 12),
            const Text(
              'AI Lens Camera Vision View',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Scanner stream initialized',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            if (widget.overlayWidget != null) widget.overlayWidget!,
          ],
        ),
      ),
    );
  }
}
