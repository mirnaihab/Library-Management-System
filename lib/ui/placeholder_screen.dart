import 'package:flutter/material.dart';

/// Stands in for a screen that a later story builds.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Center(child: Text(title));
}
