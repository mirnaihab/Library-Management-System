import '../application/library.dart';
import '../domain/category.dart';
import '../domain/clock.dart';
import '../domain/librarian.dart';
import '../domain/member.dart';

/// Fills [library] with the starting books, members and librarian.
///
/// Inserts straight into the repositories until the add-book (1.2) and
/// register-member (2.1) commands exist. [clock] lets later stories seed past
/// events by moving it backwards.
void seedSampleData(Library library, FixedClock clock) {
  const books = [
    ('The Pragmatic Programmer', 'Andrew Hunt', Category.technology, 3),
    ('Clean Code', 'Robert C. Martin', Category.technology, 2),
    ('Dune', 'Frank Herbert', Category.fiction, 4),
    ('To Kill a Mockingbird', 'Harper Lee', Category.fiction, 2),
    ('A Brief History of Time', 'Stephen Hawking', Category.science, 2),
    ('Cosmos', 'Carl Sagan', Category.science, 1),
    ('The Guns of August', 'Barbara W. Tuchman', Category.history, 1),
    ('The Very Hungry Caterpillar', 'Eric Carle', Category.children, 5),
  ];
  for (final (title, author, category, copies) in books) {
    library.bookRepository.add(
      title: title,
      author: author,
      category: category,
      copies: copies,
    );
  }

  const members = [
    ('Nour Hassan', 'nour.hassan@example.com'),
    ('Omar Farouk', 'omar.farouk@example.com'),
    ('Salma Adel', 'salma.adel@example.com'),
  ];
  for (final (name, email) in members) {
    library.memberRepository.add(Member(
      memberNumber: library.memberRepository.nextMemberNumber(),
      name: name,
      email: email,
    ));
  }

  library.librarian = Librarian(name: 'Mona Khalil');
}
