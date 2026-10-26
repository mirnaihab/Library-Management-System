import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/library.dart';
import 'package:library_management_system/data/in_memory_book_repository.dart';
import 'package:library_management_system/data/in_memory_member_repository.dart';
import 'package:library_management_system/data/sample_data.dart';
import 'package:library_management_system/domain/book.dart';
import 'package:library_management_system/domain/category.dart';
import 'package:library_management_system/domain/clock.dart';
import 'package:library_management_system/domain/day.dart';
import 'package:library_management_system/domain/member.dart';

/// Records the order of sweeps and repository reads.
final log = <String>[];

class LoggingBookRepository extends InMemoryBookRepository {
  @override
  List<Book> all() {
    log.add('books read');
    return super.all();
  }
}

class LoggingMemberRepository extends InMemoryMemberRepository {
  @override
  List<Member> all() {
    log.add('members read');
    return super.all();
  }
}

class SweepCountingLibrary extends Library {
  SweepCountingLibrary({
    required super.bookRepository,
    required super.memberRepository,
    required super.clock,
  });

  @override
  void sweep() => log.add('sweep');
}

/// Records the clock's today each time it sweeps.
class DayRecordingLibrary extends Library {
  DayRecordingLibrary(
    this.recordedClock, {
    required super.bookRepository,
    required super.memberRepository,
  }) : super(clock: recordedClock);

  final SystemClock recordedClock;
  final sweptOn = <Day>[];

  @override
  void sweep() => sweptOn.add(recordedClock.today);
}

void main() {
  late SystemClock clock;
  late LoggingBookRepository books;
  late LoggingMemberRepository members;
  late SweepCountingLibrary library;

  setUp(() {
    log.clear();
    clock = SystemClock(start: Day(2026, 1, 10));
    books = LoggingBookRepository();
    members = LoggingMemberRepository();
    library = SweepCountingLibrary(
      bookRepository: books,
      memberRepository: members,
      clock: clock,
    );
  });

  test('today comes from the clock', () {
    expect(library.today, Day(2026, 1, 10));
  });

  test('advanceClock moves today forward one day and notifies once', () {
    var notifications = 0;
    library.addListener(() => notifications++);

    library.advanceClock();

    expect(library.today, Day(2026, 1, 11));
    expect(notifications, 1);
  });

  test('books and members read through the repositories', () {
    books.add(
        title: 'Dune', author: 'Frank Herbert', category: Category.fiction, copies: 2);
    members.add(Member(memberNumber: 'M-0001', name: 'Ann', email: 'a@x.eg'));

    expect(library.books.map((b) => b.title), ['Dune']);
    expect(library.members.map((m) => m.memberNumber), ['M-0001']);
  });

  test('queries sweep before reading', () {
    library.books;
    library.members;
    expect(log, ['sweep', 'books read', 'sweep', 'members read']);
  });

  test('every public query and command sweeps', () {
    library.today;
    library.librarian;
    library.advanceClock();
    expect(log, ['sweep', 'sweep', 'sweep']);
  });

  test('catalog sweeps before reading the books', () {
    library.catalog;
    expect(log, ['sweep', 'books read']);
  });

  test('catalog lists the sample books by title A-Z', () {
    seedSampleData(library, FixedClock(Day(2026, 1, 10)));
    expect([for (final entry in library.catalog) entry.book.title], [
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

  test('catalog does not notify listeners', () {
    var notifications = 0;
    library.addListener(() => notifications++);
    library.catalog;
    expect(notifications, 0);
  });

  test('advanceClock sweeps as of the new day', () {
    final recording = DayRecordingLibrary(
      SystemClock(start: Day(2026, 1, 10)),
      bookRepository: InMemoryBookRepository(),
      memberRepository: InMemoryMemberRepository(),
    );

    recording.advanceClock();

    expect(recording.sweptOn, [Day(2026, 1, 11)]);
  });
}
