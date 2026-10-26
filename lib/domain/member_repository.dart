import 'member.dart';

abstract class MemberRepository {
  void add(Member member);

  Member? byNumber(String memberNumber);

  /// Every member, in the order they were added.
  List<Member> all();

  /// The number after the highest one issued so far, starting at M-0001.
  String nextMemberNumber();
}
