import '../domain/book.dart';
import '../domain/book_repository.dart';
import '../domain/category.dart';

class InMemoryBookRepository implements BookRepository {
  final _books = <String, Book>{};
  var _lastId = 0;

  @override
  Book add({
    required String title,
    required String author,
    required Category category,
    required int copies,
  }) {
    final book = Book(
      id: '${++_lastId}',
      title: title,
      author: author,
      category: category,
      copies: copies,
    );
    _books[book.id] = book;
    return book;
  }

  @override
  Book? byId(String id) => _books[id];

  @override
  List<Book> all() => List.unmodifiable(_books.values);
}
