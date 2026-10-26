import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/data/in_memory_book_repository.dart';
import 'package:library_management_system/domain/category.dart';

void main() {
  late InMemoryBookRepository books;

  setUp(() => books = InMemoryBookRepository());

  test('an added book can be fetched by its id', () {
    final added = books.add(
      title: 'Dune',
      author: 'Frank Herbert',
      category: Category.fiction,
      copies: 3,
    );

    final fetched = books.byId(added.id)!;
    expect(fetched.title, 'Dune');
    expect(fetched.author, 'Frank Herbert');
    expect(fetched.category, Category.fiction);
    expect(fetched.copies, 3);
  });

  test('an unknown id finds nothing', () {
    expect(books.byId('nope'), isNull);
  });

  test('all lists books in the order they were added', () {
    for (final title in ['C', 'A', 'B']) {
      books.add(
          title: title, author: 'X', category: Category.science, copies: 1);
    }
    expect(books.all().map((b) => b.title), ['C', 'A', 'B']);
  });

  test('ids are issued sequentially', () {
    final ids = [
      for (var i = 0; i < 3; i++)
        books
            .add(title: '$i', author: 'X', category: Category.history, copies: 1)
            .id,
    ];
    expect(ids, ['1', '2', '3']);
  });
}
