import 'package:flutter/material.dart';

import '../application/library.dart';
import '../application/session.dart';
import 'catalog/catalog_screen.dart';
import 'clock_control.dart';
import 'placeholder_screen.dart';
import 'role_switch.dart';

typedef _Destination = ({
  String label,
  IconData icon,
  Widget Function(Library library) screen,
});

Widget _catalog(Library library) => CatalogScreen(library: library);

/// A screen that a later story builds.
Widget Function(Library) _placeholder(String title) =>
    (_) => PlaceholderScreen(title: title);

final List<_Destination> _librarianDestinations = [
  (label: 'Catalog', icon: Icons.menu_book, screen: _catalog),
  (label: 'Members', icon: Icons.people, screen: _placeholder('Members')),
  (
    label: 'Dashboard',
    icon: Icons.dashboard,
    screen: _placeholder('Dashboard'),
  ),
];

final List<_Destination> _memberDestinations = [
  (label: 'Catalog', icon: Icons.menu_book, screen: _catalog),
  (
    label: 'My loans',
    icon: Icons.library_books,
    screen: _placeholder('My loans'),
  ),
  (
    label: 'My reservations',
    icon: Icons.bookmark,
    screen: _placeholder('My reservations'),
  ),
  (label: 'My fees', icon: Icons.payments, screen: _placeholder('My fees')),
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
      body: destinations[_index].screen(widget.library),
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
