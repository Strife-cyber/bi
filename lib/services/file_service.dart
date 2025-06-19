import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  /// Requests storage permission for Android; iOS doesn't require it for app directories.
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      return true; // iOS doesn't require permissions for app directories
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return true; // This is schemac do not do this at home
  }

  /// Returns the app's documents directory
  Future<Directory> getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Saves a file efficiently using streaming for both small and large files
  Future<String> saveFile(File sourceFile, String fileName) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      throw Exception('Storage permission not granted');
    }

    final dir = await getAppDirectory();
    if (!await dir.exists()) await dir.create(recursive: true);

    // Generate unique filename to prevent overwrites
    final sanitizedFileName = _generateUniqueFileName(fileName);
    final destPath = path.join(dir.path, sanitizedFileName);
    final destFile = File(destPath);

    try {
      // Efficient file copy using streams
      await _copyFileWithStream(sourceFile, destFile);
      return destPath;
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }

  /// Efficient file copy using streams
  Future<void> _copyFileWithStream(File source, File destination) async {
    final input = source.openRead();
    final output = destination.openWrite();

    try {
      await input.pipe(output);
    } catch (e) {
      await output.close();
      await destination.delete();
      rethrow;
    } finally {
      await output.close();
    }
  }

  /// Generates unique filename with timestamp
  String _generateUniqueFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalName);
    final baseName = path.basenameWithoutExtension(originalName);
    
    // Sanitize filename
    final sanitizedBase = baseName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll('..', '_')
        .trim();
    
    final name = sanitizedBase.isEmpty 
        ? 'file_$timestamp' 
        : '${sanitizedBase}_$timestamp';
    
    return '$name$extension';
  }

  /// Deletes a file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Checks if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      throw Exception('Failed to check file existence: $e');
    }
  }
}