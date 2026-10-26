import 'package:flutter/material.dart';

import '../application/library.dart';
import '../application/session.dart';

/// Chooses who is using the app: the librarian or one of the members.
class RoleSwitch extends StatelessWidget {
  const RoleSwitch({super.key, required this.library, required this.session});

  final Library library;
  final Session session;

  /// Dropdown value for the librarian; members use their member number.
  static const _librarian = '';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([library, session]),
      builder: (context, _) => DropdownButton<String>(
        // TODO(Story 2.1): if the selected member is no longer in
        // library.members, DropdownButton asserts; fall back to the librarian.
        value: switch (session.role) {
          LibrarianRole() => _librarian,
          MemberRole(:final memberNumber) => memberNumber,
        },
        items: [
          DropdownMenuItem(
            value: _librarian,
            child: Text('Librarian (${library.librarian?.name ?? ''})'),
          ),
          for (final member in library.members)
            DropdownMenuItem(
              value: member.memberNumber,
              child: Text('${member.memberNumber} ${member.name}'),
            ),
        ],
        onChanged: (value) {
          if (value == null) return;
          if (value == _librarian) {
            session.selectLibrarian();
          } else {
            session.selectMember(value);
          }
        },
      ),
    );
  }
}
