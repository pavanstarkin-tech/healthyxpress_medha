import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/offline_medical_models.dart';

/// Manages local filesystem paths, directories, and persistence for GGUF model files.
class ModelStorageService {
  static const _prefPrefix = 'offline_medical_gguf.';

  /// Returns the directory used to store downloaded GGUF files.
  static Future<Directory> modelsDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/medical_models');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Returns the expected filesystem path for a given model.
  static Future<String> localPathFor(GgufModel model) async {
    final dir = await modelsDirectory();
    final filename = model.filename ?? '${model.id}.gguf';
    return '${dir.path}/$filename';
  }

  /// Returns the partial-download temp path.
  static Future<String> partPathFor(GgufModel model) async {
    final base = await localPathFor(model);
    return '$base.part';
  }

  /// Returns the file size in bytes if the completed file exists.
  static Future<int?> completedFileSizeBytes(GgufModel model) async {
    final path = await localPathFor(model);
    final file = File(path);
    if (!file.existsSync()) return null;
    final stat = file.statSync();
    if (stat.size <= 0) return null;
    return stat.size;
  }

  /// Returns the byte length of a partial download (.part file).
  static Future<int> partialBytes(GgufModel model) async {
    final path = await partPathFor(model);
    final file = File(path);
    if (!file.existsSync()) return 0;
    return file.statSync().size;
  }

  /// Deletes both completed and partial files for a model.
  static Future<void> deleteFiles(GgufModel model) async {
    for (final path in [
      await localPathFor(model),
      await partPathFor(model),
    ]) {
      final f = File(path);
      if (f.existsSync()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
  }

  static String _key(String modelId, String field) => '$_prefPrefix$modelId.$field';

  /// Mark model download complete in preferences.
  static Future<void> markDownloaded(GgufModel model, String localPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(model.id, 'state'), 'downloaded');
    await prefs.setString(_key(model.id, 'path'), localPath);
  }

  /// Persist partial download byte count.
  static Future<void> markPartial(GgufModel model, int bytesDownloaded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(model.id, 'state'), 'partial');
    await prefs.setInt(_key(model.id, 'bytes'), bytesDownloaded);
  }

  /// Clear all stored metadata for a model.
  static Future<void> clearMetadata(GgufModel model) async {
    final prefs = await SharedPreferences.getInstance();
    for (final field in ['state', 'path', 'bytes']) {
      await prefs.remove(_key(model.id, field));
    }
  }

  /// Check active model ID stored in preferences.
  static Future<String?> getActiveModelId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_prefPrefix}active_model_id');
  }

  /// Persist active model ID in preferences.
  static Future<void> setActiveModelId(String modelId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefPrefix}active_model_id', modelId);
  }

  /// Reconcile model with local filesystem.
  static Future<void> reconcileModelState(GgufModel model) async {
    final path = await localPathFor(model);
    final file = File(path);
    if (file.existsSync() && file.statSync().size > 0) {
      model.downloadState = GgufDownloadState.downloaded;
      model.localPath = path;
      model.localFileBytes = file.statSync().size;
      return;
    }

    final part = await partialBytes(model);
    if (part > 0) {
      model.downloadState = GgufDownloadState.paused;
      model.downloadedBytes = part;
      return;
    }

    model.downloadState = GgufDownloadState.notDownloaded;
    model.localPath = null;
    model.localFileBytes = null;
  }
}
