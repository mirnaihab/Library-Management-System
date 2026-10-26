import '../domain/member.dart';
import '../domain/member_repository.dart';

class InMemoryMemberRepository implements MemberRepository {
  final _members = <String, Member>{};

  @override
  void add(Member member) => _members[member.memberNumber] = member;

  @override
  Member? byNumber(String memberNumber) => _members[memberNumber];

  @override
  List<Member> all() => List.unmodifiable(_members.values);

  @override
  String nextMemberNumber() {
    final highest = _members.keys
        .map((number) => int.parse(number.substring(2)))
        .fold(0, (a, b) => a > b ? a : b);
    return 'M-${(highest + 1).toString().padLeft(4, '0')}';
  }
}
