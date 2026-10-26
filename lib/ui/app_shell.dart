import 'package:flutter/material.dart';

import '../application/library.dart';
import '../application/session.dart';
import 'clock_control.dart';
import 'placeholder_screen.dart';
import 'role_switch.dart';

typedef _Destination = ({String label, IconData icon});

const List<_Destination> _librarianDestinations = [
  (label: 'Catalog', icon: Icons.menu_book),
  (label: 'Members', icon: Icons.people),
  (label: 'Dashboard', icon: Icons.dashboard),
];

const List<_Destination> _memberDestinations = [
  (label: 'Catalog', icon: Icons.menu_book),
  (label: 'My loans', icon: Icons.library_books),
  (label: 'My reservations', icon: Icons.bookmark),
  (label: 'My fees', icon: Icons.payments),
];

/// The frame every screen runs inside: role switch, dev clock and the
/// role's bottom navigation.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.library, required this.session});

  final Library library;
  final Session session;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _index = 0;

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_onRoleChanged);
  }

  @override
  void dispose() {
    widget.session.removeListener(_onRoleChanged);
    super.dispose();
  }

  /// A new role gets its own navigation, opened at its first destination.
  void _onRoleChanged() => setState(() => _index = 0);

  @override
  Widget build(BuildContext context) {
    final destinations = switch (widget.session.role) {
      LibrarianRole() => _librarianDestinations,
      MemberRole() => _memberDestinations,
    };
    return Scaffold(
      appBar: AppBar(
        title: RoleSwitch(library: widget.library, session: widget.session),
        actions: [ClockControl(library: widget.library)],
      ),
      body: PlaceholderScreen(title: destinations[_index].label),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}
