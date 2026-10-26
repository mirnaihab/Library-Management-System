import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/rule_violation.dart';

/// Runs [action], showing any [RuleViolation] word for word in a SnackBar.
///
/// Awaits [action], so a violation thrown by an async action is shown too.
Future<void> runGuarded(
  BuildContext context,
  FutureOr<void> Function() action,
) async {
  try {
    await action();
  } on RuleViolation catch (violation) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(violation.message)));
  }
}
