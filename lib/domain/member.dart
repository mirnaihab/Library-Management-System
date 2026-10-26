enum MemberStatus { active, suspended }

class Member {
  Member({
    required this.memberNumber,
    required this.name,
    required this.email,
    this.status = MemberStatus.active,
  });

  /// In the form M-0001.
  final String memberNumber;
  final String name;
  final String email;
  final MemberStatus status;
}
