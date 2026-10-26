import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/category.dart';

void main() {
  test('the categories are exactly the five fixed subjects, in order', () {
    expect(Category.values.map((c) => c.displayName), [
      'Fiction',
      'Science',
      'History',
      'Technology',
      'Children',
    ]);
  });
}
