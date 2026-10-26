import 'category.dart';

class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.copies,
  });

  /// Internal identifier, never shown to the user.
  final String id;
  final String title;
  final String author;
  final Category category;
  final int copies;
}
