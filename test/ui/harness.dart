import 'package:library_management_system/application/library.dart';
import 'package:library_management_system/data/in_memory_book_repository.dart';
import 'package:library_management_system/data/in_memory_member_repository.dart';
import 'package:library_management_system/data/sample_data.dart';
import 'package:library_management_system/domain/clock.dart';
import 'package:library_management_system/domain/day.dart';

/// A library holding the sample data, starting on [start].
Library seededLibrary({Day? start}) {
  final library = Library(
    bookRepository: InMemoryBookRepository(),
    memberRepository: InMemoryMemberRepository(),
    clock: SystemClock(start: start ?? Day(2026, 10, 26)),
  );
  seedSampleData(library, FixedClock(library.today));
  return library;
}
