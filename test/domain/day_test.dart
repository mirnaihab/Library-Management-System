import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/day.dart';

void main() {
  group('Day', () {
    test('days with the same year, month and day are equal', () {
      expect(Day(2026, 1, 10), Day(2026, 1, 10));
      expect(Day(2026, 1, 10).hashCode, Day(2026, 1, 10).hashCode);
      expect(Day(2026, 1, 10), isNot(Day(2026, 1, 11)));
    });

    test('earlier days order before later days', () {
      expect(Day(2026, 1, 10) < Day(2026, 1, 11), isTrue);
      expect(Day(2026, 12, 31) < Day(2027, 1, 1), isTrue);
      expect(Day(2026, 1, 11) < Day(2026, 1, 10), isFalse);
      expect(Day(2026, 2, 1).compareTo(Day(2026, 1, 31)), greaterThan(0));
    });

    test('addDays crosses a month boundary', () {
      expect(Day(2026, 1, 30).addDays(3), Day(2026, 2, 2));
    });

    test('addDays crosses a year boundary', () {
      expect(Day(2026, 12, 31).addDays(1), Day(2027, 1, 1));
    });

    test('daysUntil counts calendar days', () {
      expect(Day(2026, 1, 10).daysUntil(Day(2026, 1, 13)), 3);
    });

    test('fromDateTime ignores the time of day', () {
      expect(Day.fromDateTime(DateTime(2026, 10, 26, 23, 59)),
          Day(2026, 10, 26));
    });
  });
}
