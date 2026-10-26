import 'package:flutter/material.dart';

import '../../application/library.dart';
import '../../domain/catalog.dart';

/// Lists every book in the catalog with its availability.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.library});

  final Library library;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        final catalog = library.catalog;
        if (catalog.isEmpty) {
          return const Center(child: Text('The catalog is empty'));
        }
        return ListView(
          children: [
            for (final entry in catalog)
              ListTile(
                title: Text(entry.book.title),
                subtitle: Text(
                  '${entry.book.author} · ${entry.book.category.displayName}',
                ),
                trailing: Text(availabilityText(entry)),
              ),
          ],
        );
      },
    );
  }
}

/// A book's availability, e.g. "2 of 3 available".
String availabilityText(CatalogEntry entry) =>
    '${entry.availableCopies} of ${entry.book.copies} available';
