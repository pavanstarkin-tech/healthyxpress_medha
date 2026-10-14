import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/offline_medical_models.dart';
import '../providers/offline_medical_slm_provider.dart';

/// Modal bottom sheet allowing users to view, download, switch,
/// or import on-device Medical SLM GGUF models.
class OfflineModelManagerSheet extends StatelessWidget {
  const OfflineModelManagerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OfflineModelManagerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfflineMedicalSlmProvider>(
      builder: (context, provider, _) {
        final models = provider.catalogModels;
        final activeModel = provider.activeModel;

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF0D1527),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: Column(
            children: [
              // Sheet Handle Bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E60F6).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.memory_rounded, color: Color(0xFF38BDF8), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'On-Device Medical SLMs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '100% Offline • Zero Data Leaves Device',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Device RAM & CPU Info Banner
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.speed_rounded, color: Color(0xFF38BDF8), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Engine: llama.cpp ARM64 CPU • Recommended RAM: ≥4 GB. Quantized to Q4_K_M for maximum battery efficiency.',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ),

              // Models List
              Expanded(
                child: models.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xFF1E60F6)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        itemCount: models.length,
                        itemBuilder: (context, index) {
                          final model = models[index];
                          final isActive = activeModel?.id == model.id;
                          return _buildModelCard(context, provider, model, isActive);
                        },
                      ),
              ),

              // Import Custom GGUF Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    side: const BorderSide(color: Color(0xFF38BDF8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.file_open_rounded, size: 20),
                  label: const Text(
                    'Import Custom .gguf Model from Storage',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result != null && result.files.single.path != null) {
                        final path = result.files.single.path!;
                        if (path.endsWith('.gguf')) {
                          final customModel = GgufModel(
                            id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                            name: result.files.single.name,
                            parameters: 'Custom',
                            quantization: 'User',
                            sizeLabel: '${(result.files.single.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                            sizeBytes: result.files.single.size,
                            type: 'custom',
                            promptFormat: 'chatml',
                            downloadState: GgufDownloadState.downloaded,
                            localPath: path,
                            localFileBytes: result.files.single.size,
                          );
                          await provider.loadModelIntoEngine(customModel);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Loaded custom model: ${result.files.single.name}')),
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a valid .gguf model file.')),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      debugPrint('File picker error: $e');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelCard(BuildContext context, OfflineMedicalSlmProvider provider, GgufModel model, bool isActive) {
    final isDownloading = model.downloadState == GgufDownloadState.downloading;
    final isDownloaded = model.isOnDisk;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E293B) : const Color(0xFF131D33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF38BDF8) : Colors.white12,
          width: isActive ? 1.8 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            model.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${model.parameters} • ${model.quantization} • ${model.sizeLabel}',
                      style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Action Button
              if (isDownloaded)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isActive ? const Color(0xFF10B981) : const Color(0xFF1E60F6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => provider.loadModelIntoEngine(model),
                  child: Text(
                    isActive ? 'Loaded' : 'Select',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              else if (isDownloading)
                IconButton(
                  icon: const Icon(Icons.pause_circle_filled_rounded, color: Colors.amber, size: 28),
                  onPressed: () => provider.downloadService.pause(model.id),
                )
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.download_rounded, size: 16, color: Colors.white),
                  label: const Text(
                    'Download',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: model.canDownload ? () => provider.downloadModel(model) : null,
                ),
            ],
          ),

          // Download Progress bar
          if (isDownloading) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: model.downloadFraction,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF38BDF8)),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.downloadProgressLabel,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                ),
                Text(
                  '${model.speedLabel ?? ''} • ETA: ${model.etaLabel ?? 'calc...'}',
                  style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],

          if (model.notes != null) ...[
            const SizedBox(height: 6),
            Text(
              model.notes!,
              style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
