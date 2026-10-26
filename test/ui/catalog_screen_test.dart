import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/library.dart';
import 'package:library_management_system/data/in_memory_book_repository.dart';
import 'package:library_management_system/data/in_memory_member_repository.dart';
import 'package:library_management_system/domain/clock.dart';
import 'package:library_management_system/domain/day.dart';
import 'package:library_management_system/ui/catalog/catalog_screen.dart';

import 'harness.dart';

Future<void> _pump(WidgetTester tester, Library library) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: CatalogScreen(library: library)),
  ));
}

Finder _row(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(ListTile));

void main() {
  testWidgets('sample books are listed by title', (tester) async {
    await _pump(tester, seededLibrary());

    final titles = [
      for (final tile in tester.widgetList<ListTile>(find.byType(ListTile)))
        (tile.title! as Text).data,
    ];
    expect(titles, [
      'A Brief History of Time',
      'Clean Code',
      'Cosmos',
      'Dune',
      'The Guns of August',
      'The Pragmatic Programmer',
      'The Very Hungry Caterpillar',
      'To Kill a Mockingbird',
    ]);
  });

  testWidgets('a row shows author, category and availability',
      (tester) async {
    await _pump(tester, seededLibrary());

    final row = _row('The Pragmatic Programmer');
    expect(row, findsOneWidget);
    expect(
        find.descendant(
            of: row, matching: find.text('Andrew Hunt · Technology')),
        findsOneWidget);
    expect(find.descendant(of: row, matching: find.text('3 of 3 available')),
        findsOneWidget);
  });

  testWidgets('a single copy reads 1 of 1 available', (tester) async {
    await _pump(tester, seededLibrary());

    final row = _row('Cosmos');
    expect(row, findsOneWidget);
    expect(find.descendant(of: row, matching: find.text('1 of 1 available')),
        findsOneWidget);
  });

  testWidgets('a library with no books shows the empty message',
      (tester) async {
    await _pump(
      tester,
      Library(
        bookRepository: InMemoryBookRepository(),
        memberRepository: InMemoryMemberRepository(),
        clock: SystemClock(start: Day(2026, 10, 26)),
      ),
    );

    expect(find.text('The catalog is empty'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
