import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/day.dart';
import 'package:library_management_system/ui/clock_control.dart';

import 'harness.dart';

void main() {
  testWidgets('three presses of +1 day from 2026-01-30 show 2026-02-02',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ClockControl(library: seededLibrary(start: Day(2026, 1, 30))),
      ),
    ));
    expect(find.text('2026-01-30'), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('+1 day'));
      await tester.pump();
    }

    expect(find.text('2026-02-02'), findsOneWidget);
  });
}
