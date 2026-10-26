import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/session.dart';
import 'package:library_management_system/ui/app_shell.dart';

import 'harness.dart';

void main() {
  late Session session;

  Future<void> pumpShell(WidgetTester tester) {
    session = Session();
    return tester.pumpWidget(MaterialApp(
      home: AppShell(library: seededLibrary(), session: session),
    ));
  }

  List<String> destinations(WidgetTester tester) => tester
      .widgetList<NavigationDestination>(find.byType(NavigationDestination))
      .map((d) => d.label)
      .toList();

  int selectedIndex(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

  testWidgets('the librarian sees Catalog, Members and Dashboard',
      (tester) async {
    await pumpShell(tester);
    expect(destinations(tester), ['Catalog', 'Members', 'Dashboard']);
  });

  testWidgets('a member sees Catalog, My loans, My reservations and My fees',
      (tester) async {
    await pumpShell(tester);
    session.selectMember('M-0001');
    await tester.pumpAndSettle();
    expect(destinations(tester),
        ['Catalog', 'My loans', 'My reservations', 'My fees']);
  });

  testWidgets('switching role from Dashboard opens the member Catalog',
      (tester) async {
    await pumpShell(tester);
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(selectedIndex(tester), 2);

    await tester.tap(find.text('Librarian (Mona Khalil)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('M-0001 Nour Hassan').last);
    await tester.pumpAndSettle();

    expect(destinations(tester),
        ['Catalog', 'My loans', 'My reservations', 'My fees']);
    expect(selectedIndex(tester), 0);
  });
}
