// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:internship/utilities/date.dart';

void main() {
  group('formatTimestamp', () {
    test('formats timestamp correctly', () {
      // June 13, 2025 4:00 PM UTC
      final timestamp = DateTime.utc(2025, 6, 13, 16, 0).millisecondsSinceEpoch;

      final formatted = formatTimestamp(timestamp);

      // Note: Result will depend on local timezone
      expect(formatted, contains('Jun 13')); // Just check that the date is part of the string
    });
  });

  group('getRandomColor', () {
    test('returns a valid opaque color', () {
      final color = getRandomColor();

      expect(color.alpha, equals(255));
      expect(color.red, inInclusiveRange(0, 255));
      expect(color.green, inInclusiveRange(0, 255));
      expect(color.blue, inInclusiveRange(0, 255));
    });

    test('returns different colors over multiple calls', () {
      final colors = List.generate(10, (_) => getRandomColor());

      // There should be at least some variation in colors
      final uniqueColors = colors.toSet();
      expect(uniqueColors.length > 1, true);
    });
  });
}
