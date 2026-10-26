import 'package:flutter/foundation.dart';

/// Who is using the app: the librarian, or a member acting as themselves.
sealed class Role {
  const Role();
}

class LibrarianRole extends Role {
  const LibrarianRole();
}

class MemberRole extends Role {
  const MemberRole(this.memberNumber);

  final String memberNumber;
}

class Session extends ChangeNotifier {
  Role _role = const LibrarianRole();

  Role get role => _role;

  void selectLibrarian() => _select(const LibrarianRole());

  void selectMember(String memberNumber) => _select(MemberRole(memberNumber));

  void _select(Role role) {
    _role = role;
    notifyListeners();
  }
}
