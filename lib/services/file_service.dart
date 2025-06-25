import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FileService {
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final String apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final String apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

  /// Uploads file to Cloudinary and returns the secure URL
  Future<String> uploadFileToCloudinary(File file) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final fileBytes = await file.readAsBytes();

      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      // Generate signature manually
      final signatureData = 'timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(signatureData)).toString();

      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['api_key'] = apiKey
        ..fields['timestamp'] = timestamp
        ..fields['signature'] = signature
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: path.basename(file.path),
          contentType: MediaType.parse(mimeType),
        ));

      final response = await request.send();
      final body = await http.Response.fromStream(response);

      if (body.statusCode == 200) {
        final data = json.decode(body.body);
        return data['secure_url'];
      } else {
        throw Exception('Cloudinary error: ${body.body}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
}
