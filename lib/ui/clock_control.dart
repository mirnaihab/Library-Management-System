import 'package:flutter/material.dart';

import '../application/library.dart';
import '../domain/day.dart';

/// Dev control showing today and moving it forward one day.
class ClockControl extends StatelessWidget {
  const ClockControl({super.key, required this.library});

  final Library library;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formatDay(library.today)),
          TextButton(
            onPressed: library.advanceClock,
            child: const Text('+1 day'),
          ),
        ],
      ),
    );
  }
}

/// YYYY-MM-DD.
String formatDay(Day day) => '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
