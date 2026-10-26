import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/rule_violation.dart';
import 'package:library_management_system/ui/rule_violation_display.dart';

void main() {
  testWidgets('a rule violation is shown word for word', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => runGuarded(
              context,
              () => throw RuleViolation('Your account is suspended'),
            ),
            child: const Text('Borrow'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Borrow'));
    await tester.pump();

    expect(find.descendant(
        of: find.byType(SnackBar),
        matching: find.text('Your account is suspended')), findsOneWidget);
  });
}
