import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/clock.dart';
import 'package:library_management_system/domain/day.dart';

void main() {
  group('FixedClock', () {
    test('today is the day it was set to', () {
      expect(FixedClock(Day(2026, 1, 10)).today, Day(2026, 1, 10));
    });

    test('today follows a new day being set', () {
      final clock = FixedClock(Day(2026, 1, 10));
      clock.today = Day(2025, 12, 1);
      expect(clock.today, Day(2025, 12, 1));
    });
  });

  group('SystemClock', () {
    test('today starts at the start day', () {
      expect(SystemClock(start: Day(2026, 10, 26)).today, Day(2026, 10, 26));
    });

    test('advance moves today forward one day each time', () {
      final clock = SystemClock(start: Day(2026, 1, 30));
      clock.advance();
      clock.advance();
      clock.advance();
      expect(clock.today, Day(2026, 2, 2));
    });
  });
}
