/// A calendar day with no time of day.
///
/// Backed by a UTC midnight so daylight-saving changes can't shift a day.
class Day implements Comparable<Day> {
  /// Throws [ArgumentError] for a date that doesn't exist, such as 2026-02-30.
  factory Day(int year, int month, int day) {
    final result = Day._(DateTime.utc(year, month, day));
    if (result.year != year || result.month != month || result.day != day) {
      throw ArgumentError('Not a calendar day: $year-$month-$day');
    }
    return result;
  }

  Day.fromDateTime(DateTime dateTime)
      : this._(DateTime.utc(dateTime.year, dateTime.month, dateTime.day));

  Day._(this._utc);

  final DateTime _utc;

  int get year => _utc.year;
  int get month => _utc.month;
  int get day => _utc.day;

  Day addDays(int days) => Day._(DateTime.utc(year, month, day + days));

  int daysUntil(Day other) => other._utc.difference(_utc).inDays;

  bool operator <(Day other) => compareTo(other) < 0;

  @override
  int compareTo(Day other) => _utc.compareTo(other._utc);

  @override
  bool operator ==(Object other) => other is Day && other._utc == _utc;

  @override
  int get hashCode => _utc.hashCode;
}
