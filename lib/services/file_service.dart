import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      return status.isGranted;
    }

    return true;
  }

  Future<Directory> getAppDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  Future<File> saveFile(List<int> fileBytes, String fileName) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      throw Exception('Storage permission not granted');
    }

    final dir = await getAppDirectory();

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    return await file.writeAsBytes(fileBytes);
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }
}