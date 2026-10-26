import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/data/in_memory_member_repository.dart';
import 'package:library_management_system/domain/member.dart';

Member _member(String number) =>
    Member(memberNumber: number, name: 'Name $number', email: '$number@x.eg');

void main() {
  late InMemoryMemberRepository members;

  setUp(() => members = InMemoryMemberRepository());

  test('an added member can be fetched by member number', () {
    members.add(_member('M-0001'));
    expect(members.byNumber('M-0001')!.name, 'Name M-0001');
  });

  test('an unknown member number finds nothing', () {
    expect(members.byNumber('M-0009'), isNull);
  });

  test('all lists members in the order they were added', () {
    members
      ..add(_member('M-0002'))
      ..add(_member('M-0001'));
    expect(members.all().map((m) => m.memberNumber), ['M-0002', 'M-0001']);
  });

  test('the first member number is M-0001', () {
    expect(members.nextMemberNumber(), 'M-0001');
  });

  test('member numbers continue after the highest existing one', () {
    members
      ..add(_member('M-0001'))
      ..add(_member('M-0002'))
      ..add(_member('M-0003'));
    expect(members.nextMemberNumber(), 'M-0004');
  });
}
