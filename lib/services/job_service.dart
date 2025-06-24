import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class JobService {
  final Dio _dio = Dio();
  final String schedulerUrl = 'https://bi-394i.onrender.com/'; // Update according to ip later on

  Future<Map<String, dynamic>> submitJob({
    required List<String> files,
    required String userId,
    required String projectId,
    required String type,
  }) async {
    final formData = FormData();

    for (final filepath in files) {
      File file = File(filepath);
      final fileName = p.basename(file.path);
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(file.path, filename: fileName),
      ));
    }

    formData.fields.addAll([
      MapEntry('userId', userId),
      MapEntry('projectId', projectId),
      MapEntry('type', type),
    ]);

    try {
      final response = await _dio.post(
        '$schedulerUrl/enqueue-job',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'jobId': response.data['jobId']};
      } else {
        return {'success': false, 'message': 'Unexpected status code: ${response.statusCode}'};
      }
    } catch (e) {
      debugPrint('Upload failed: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
}