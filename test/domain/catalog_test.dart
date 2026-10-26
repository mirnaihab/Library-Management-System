import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/book.dart';
import 'package:library_management_system/domain/catalog.dart';
import 'package:library_management_system/domain/category.dart';

var _nextId = 0;

Book _book(String title, {String author = 'Author', int copies = 1}) => Book(
      id: '${++_nextId}',
      title: title,
      author: author,
      category: Category.fiction,
      copies: copies,
    );

List<String> _titles(List<CatalogEntry> catalog) =>
    [for (final entry in catalog) entry.book.title];

void main() {
  test('one entry per book', () {
    final books = [_book('Dune'), _book('Cosmos')];
    expect(catalogOf(books).map((e) => e.book), unorderedEquals(books));
  });

  test('with no loans or holds, every copy is available', () {
    expect(catalogOf([_book('Dune', copies: 3)]).single.availableCopies, 3);
  });

  test('sorted by title, ignoring capital letters', () {
    expect(_titles(catalogOf([_book('cosmos'), _book('Clean Code')])),
        ['Clean Code', 'cosmos']);
  });

  test('sorted by title, ignoring surrounding spaces', () {
    expect(_titles(catalogOf([_book('Dune'), _book('  Cosmos ')])),
        ['  Cosmos ', 'Dune']);
  });

  test('a leading "The" stays part of the title', () {
    expect(_titles(catalogOf([_book('The Guns of August'), _book('Dune')])),
        ['Dune', 'The Guns of August']);
  });

  test('books with the same title are ordered by author', () {
    final catalog = catalogOf([
      _book('Dune', author: 'Frank Herbert'),
      _book('Dune', author: 'brian Herbert'),
    ]);
    expect([for (final e in catalog) e.book.author],
        ['brian Herbert', 'Frank Herbert']);
  });

  test('no books gives an empty catalog', () {
    expect(catalogOf([]), isEmpty);
  });
}
