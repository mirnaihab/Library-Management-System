import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/book.dart';
import 'package:library_management_system/domain/catalog.dart';
import 'package:library_management_system/domain/category.dart';
import 'package:library_management_system/ui/catalog/catalog_screen.dart';

CatalogEntry _entry({required int copies, required int available}) =>
    CatalogEntry(
      book: Book(
        id: '1',
        title: 'Dune',
        author: 'Frank Herbert',
        category: Category.fiction,
        copies: copies,
      ),
      availableCopies: available,
    );

void main() {
  test('every copy available', () {
    expect(availabilityText(_entry(copies: 3, available: 3)),
        '3 of 3 available');
  });

  test('some copies available', () {
    expect(availabilityText(_entry(copies: 3, available: 2)),
        '2 of 3 available');
  });

  test('a single copy', () {
    expect(availabilityText(_entry(copies: 1, available: 1)),
        '1 of 1 available');
  });

  test('no copy available keeps the same format', () {
    expect(availabilityText(_entry(copies: 3, available: 0)),
        '0 of 3 available');
  });
}
