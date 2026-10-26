import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/library.dart';
import 'package:library_management_system/data/in_memory_book_repository.dart';
import 'package:library_management_system/data/in_memory_member_repository.dart';
import 'package:library_management_system/data/sample_data.dart';
import 'package:library_management_system/domain/category.dart';
import 'package:library_management_system/domain/clock.dart';
import 'package:library_management_system/domain/day.dart';
import 'package:library_management_system/domain/member.dart';

void main() {
  late Library library;

  setUp(() {
    library = Library(
      bookRepository: InMemoryBookRepository(),
      memberRepository: InMemoryMemberRepository(),
      clock: SystemClock(start: Day(2026, 10, 26)),
    );
    seedSampleData(library, FixedClock(Day(2026, 10, 26)));
  });

  test('8 books covering every category', () {
    expect(library.books, hasLength(8));
    expect(library.books.map((b) => b.category).toSet(),
        Category.values.toSet());
  });

  test('"The Pragmatic Programmer" is in the catalog', () {
    expect(library.books.map((b) => b.title), contains('The Pragmatic Programmer'));
  });

  test('every book has 1 to 20 copies', () {
    for (final book in library.books) {
      expect(book.copies, inInclusiveRange(1, 20), reason: book.title);
    }
  });

  test('no two books share a title and author, ignoring case and spaces', () {
    final keys = library.books.map((b) =>
        '${b.title.trim().toLowerCase()}|${b.author.trim().toLowerCase()}');
    expect(keys.toSet(), hasLength(8));
  });

  test('members M-0001 to M-0003 are all Active with unique emails', () {
    final members = library.members;
    expect(members.map((m) => m.memberNumber), ['M-0001', 'M-0002', 'M-0003']);
    expect(members.map((m) => m.status), everyElement(MemberStatus.active));
    expect(members.map((m) => m.email.toLowerCase()).toSet(), hasLength(3));
  });

  // TODO(Story 2.1): this only checks the librarian has a name; it can't catch
  // a second librarian while Library stores a single one.
  test('there is exactly one librarian', () {
    expect(library.librarian?.name, isNotEmpty);
  });

  test('the next member number is M-0004', () {
    expect(library.memberRepository.nextMemberNumber(), 'M-0004');
  });
}
