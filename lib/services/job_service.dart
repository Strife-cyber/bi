import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class JobService {
  final Dio _dio = Dio();
  final String schedulerUrl = 'http://laptop-mdpv1f76.taild0a5b5.ts.net:3001'; // Update according to ip later on

  Future<Map<String, dynamic>> submitJob({
    required List<String> files,
    required String userId,
    required String projectId,
    required String type,
  }) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('userId', userId),
      MapEntry('projectId', projectId),
      MapEntry('type', type),
      MapEntry('analysis', jsonEncode(files))
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