import 'package:flutter/material.dart';

import 'application/library.dart';
import 'application/session.dart';
import 'data/in_memory_book_repository.dart';
import 'data/in_memory_member_repository.dart';
import 'data/sample_data.dart';
import 'domain/clock.dart';
import 'domain/day.dart';
import 'ui/app_shell.dart';

void main() {
  final library = Library(
    bookRepository: InMemoryBookRepository(),
    memberRepository: InMemoryMemberRepository(),
    clock: SystemClock(start: Day.fromDateTime(DateTime.now())),
  );
  seedSampleData(library, FixedClock(library.today));
  runApp(LibraryApp(library: library, session: Session()));
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key, required this.library, required this.session});

  final Library library;
  final Session session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library',
      home: AppShell(library: library, session: session),
    );
  }
}
