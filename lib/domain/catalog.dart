import 'book.dart';

/// A book as the catalog shows it, with its available copies.
class CatalogEntry {
  CatalogEntry({required this.book, required this.availableCopies});

  final Book book;
  final int availableCopies;
}

/// Every book with its available copies, sorted by title then author,
/// ignoring capital letters and surrounding spaces.
///
/// Available copies are copies minus open loans minus holds (ADR 0002);
/// loans and holds are subtracted here once Stories 3.1 and 6.2 add them.
List<CatalogEntry> catalogOf(List<Book> books) {
  final entries = [
    for (final book in books)
      CatalogEntry(book: book, availableCopies: book.copies),
  ];
  return entries..sort((a, b) => _compare(a.book, b.book));
}

int _compare(Book a, Book b) {
  final byTitle = _key(a.title).compareTo(_key(b.title));
  return byTitle != 0 ? byTitle : _key(a.author).compareTo(_key(b.author));
}

String _key(String text) => text.trim().toLowerCase();
