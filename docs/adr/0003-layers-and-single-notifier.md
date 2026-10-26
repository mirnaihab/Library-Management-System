# Layers with one notifier and no state-management package

The code is split into `lib/domain/` (plain Dart entities, rules, `Clock` and repository interfaces), `lib/data/` (in-memory repositories and sample data), `lib/application/` (the library service) and `lib/ui/`. The UI listens to one `ChangeNotifier` that announces a change after every command, with no Provider, Riverpod or Bloc. All data lives in one place and every screen depends on it (Story 7.1.4: numbers update after any borrow, return or payment), so a single notifier is enough and `pubspec.yaml` needs only Flutter. Breaking a rule throws a single `RuleViolation(message)`, carrying the exact text from `docs/stories.md`, and the UI shows that message.

## Consequences

- Every public method of the library service first runs the hold-expiry sweep (Story 6.3.4) as of the clock's today, then does its work. No screen checks expiry on its own.
- Domain code imports nothing from Flutter. Tests, including domain tests, may use `flutter_test`, so `pubspec.yaml` needs no separate `test` package.
