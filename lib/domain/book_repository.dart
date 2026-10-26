import 'book.dart';
import 'category.dart';

abstract class BookRepository {
  /// Stores a new book under the next internal id and returns it.
  Book add({
    required String title,
    required String author,
    required Category category,
    required int copies,
  });

  Book? byId(String id);

  /// Every book, in the order it was added.
  List<Book> all();
}
