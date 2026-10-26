import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/application/session.dart';

void main() {
  late Session session;

  setUp(() => session = Session());

  test('starts as the librarian', () {
    expect(session.role, isA<LibrarianRole>());
  });

  test('selecting a member acts as that member and notifies', () {
    var notifications = 0;
    session.addListener(() => notifications++);

    session.selectMember('M-0002');

    expect(
      session.role,
      isA<MemberRole>().having((r) => r.memberNumber, 'memberNumber', 'M-0002'),
    );
    expect(notifications, 1);
  });

  test('selecting the librarian switches back', () {
    session.selectMember('M-0002');
    session.selectLibrarian();
    expect(session.role, isA<LibrarianRole>());
  });
}
