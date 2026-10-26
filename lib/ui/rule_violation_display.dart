import 'package:flutter/material.dart';

import '../domain/rule_violation.dart';

/// Runs [action], showing any [RuleViolation] word for word in a SnackBar.
void runGuarded(BuildContext context, void Function() action) {
  try {
    action();
  } on RuleViolation catch (violation) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(violation.message)));
  }
}
