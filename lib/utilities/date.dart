import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('MMM d, h:mm a').format(date); // e.g., Jun 13, 4:00 PM
}

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255,                     // Fully opaque
    random.nextInt(256),     // Red (0–255)
    random.nextInt(256),     // Green
    random.nextInt(256),     // Blue
  );
}

