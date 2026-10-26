import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/session.dart';
import 'package:library_management_system/ui/role_switch.dart';

import 'harness.dart';

void main() {
  late Session session;

  Future<void> pumpSwitch(WidgetTester tester) {
    session = Session();
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RoleSwitch(library: seededLibrary(), session: session),
      ),
    ));
  }

  testWidgets('starts on the librarian', (tester) async {
    await pumpSwitch(tester);
    expect(find.text('Librarian (Mona Khalil)'), findsOneWidget);
  });

  testWidgets('lists the librarian, then every member, in order', (tester) async {
    await pumpSwitch(tester);

    final dropdown =
        tester.widget<DropdownButton<String>>(find.byType(DropdownButton<String>));
    expect(dropdown.items!.map((item) => (item.child as Text).data), [
      'Librarian (Mona Khalil)',
      'M-0001 Nour Hassan',
      'M-0002 Omar Farouk',
      'M-0003 Salma Adel',
    ]);
  });

  testWidgets('picking M-0002 acts as that member', (tester) async {
    await pumpSwitch(tester);
    await tester.tap(find.byType(RoleSwitch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M-0002 Omar Farouk').last);
    await tester.pumpAndSettle();

    expect(
      session.role,
      isA<MemberRole>().having((r) => r.memberNumber, 'memberNumber', 'M-0002'),
    );
    expect(find.text('M-0002 Omar Farouk'), findsOneWidget);
  });
}
