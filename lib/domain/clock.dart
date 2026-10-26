import 'day.dart';

abstract class Clock {
  Day get today;
}

/// A clock whose day is set by hand, for tests and seeding sample data.
class FixedClock implements Clock {
  FixedClock(this.today);

  @override
  Day today;
}

/// The app's clock: starts at the device date, moved forward by the dev control.
class SystemClock implements Clock {
  SystemClock({required this._start});

  final Day _start;
  int _offsetDays = 0;

  @override
  Day get today => _start.addDays(_offsetDays);

  void advance() => _offsetDays++;
}
