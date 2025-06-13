import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/services/auth_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService(firebaseDatabaseUrl: 'https://internship-b6df0-default-rtdb.firebaseio.com', uid: ref.read(authServiceProvider).currentUser!.uid));

class NotificationService {
  final String firebaseDatabaseUrl;
  final String uid;

  NotificationService({required this.firebaseDatabaseUrl, required this.uid});

  Future<String?> addNotification(String message) async {

    final payload = {
      "message": message,
      "read": false,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    final url = Uri.parse('$firebaseDatabaseUrl/notifications/$uid.json');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Returns Firebase generated ID (e.g. {"name": "-Nabc123xyz"})
      return data['name'];
    } else {
      debugPrint('Failed to add notification: ${response.body}');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final url = Uri.parse('$firebaseDatabaseUrl/notifications/$uid.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) return [];

      // Convert map of id -> notification into list with id included
      return (data as Map<String, dynamic>).entries
          .map((e) => {"id": e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    } else {
      debugPrint('Failed to fetch notifications: ${response.body}');
      return [];
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    final url =
        Uri.parse('$firebaseDatabaseUrl/notifications/$uid/$notificationId.json');

    final payload = {
      "read": true,
      "readAt": DateTime.now().millisecondsSinceEpoch,
    };

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('Failed to mark as read: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    final url =
        Uri.parse('$firebaseDatabaseUrl/notifications/$uid/$notificationId.json');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint('Failed to delete notification: ${response.body}');
      return false;
    }
  }
}
