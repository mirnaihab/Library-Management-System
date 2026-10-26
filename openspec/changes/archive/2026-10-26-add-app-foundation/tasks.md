# Tasks

## 1. Scaffolding

- [x] 1.1 Create `lib/domain`, `lib/data`, `lib/application`, `lib/ui` and the matching `test/` folders. Delete the template app body from `lib/main.dart`. Verify that `flutter analyze` passes.

## 2. Day and Clock (domain)

- [x] 2.1 Write failing tests for `Day`: equality, ordering, `addDays` across a month and a year boundary (2026-01-30 + 3 = 2026-02-02, 2026-12-31 + 1 = 2027-01-01), `daysUntil` (2026-01-10 → 2026-01-13 = 3), and building a `Day` from `DateTime(2026, 10, 26, 23, 59)` giving 2026-10-26. Verify that `flutter test test/domain/day_test.dart` fails.
- [x] 2.2 Implement `Day` in `lib/domain/day.dart`. Verify that the 2.1 tests pass.
- [x] 2.3 Write failing tests for `FixedClock` (returns and updates its set day) and `SystemClock` (today = the injected start date, plus the offset after `advance()`). Inject the start date so the tests never call `DateTime.now()`. Verify that the tests fail.
- [x] 2.4 Implement `Clock`, `FixedClock` and `SystemClock` in `lib/domain/clock.dart`. Verify that the 2.3 tests pass, and that `grep -r "DateTime.now" lib/domain` returns nothing.

## 3. Rule violations and entities (domain)

- [x] 3.1 Add `RuleViolation` (`lib/domain/rule_violation.dart`) with a `message` field, and a test that `throwsA(isA<RuleViolation>().having((e) => e.message, 'message', 'x'))` matches. Verify that the test passes.
- [x] 3.2 Add `Category` (exactly Fiction, Science, History, Technology, Children, with display names), `Book` (id, title, author, category, copies), `Member` (member number, name, email, status Active or Suspended) and `Librarian` (name), following `GLOSSARY.md`. Verify with a test that `Category.values` lists the 5 categories in order.

## 4. Repositories (data)

- [x] 4.1 Write failing tests for the in-memory book repository: add, then get by id, list all in insertion order, and sequential internal ids. Verify that the tests fail.
- [x] 4.2 Add the `BookRepository` interface (`lib/domain`) and `InMemoryBookRepository` (`lib/data`). Verify that the 4.1 tests pass.
- [x] 4.3 Write failing tests for the in-memory member repository: add, get by member number, list all, and `nextMemberNumber()` returning M-0001 when empty and M-0004 after M-0001 to M-0003. Verify that the tests fail.
- [x] 4.4 Add the `MemberRepository` interface and `InMemoryMemberRepository`. Verify that the 4.3 tests pass.

## 5. Library service and session (application)

- [x] 5.1 Write failing tests for `Library`: `today` comes from the injected clock, `advanceClock()` moves today forward by 1 and notifies listeners once, every public query and command runs the sweep first (checked with a counting test double), and `books` and `members` read through the repositories. Verify that the tests fail.
- [x] 5.2 Implement `Library extends ChangeNotifier` in `lib/application/library.dart`, with an empty `_sweep()` hook. Verify that the 5.1 tests pass.
- [x] 5.3 Write failing tests for `Session`: starts as Librarian, `selectMember('M-0002')` switches to Member mode for M-0002 and notifies, and `selectLibrarian()` switches back. Verify that the tests fail.
- [x] 5.4 Implement `Session` in `lib/application/session.dart`. Verify that the 5.3 tests pass.

## 6. Sample data (data)

- [x] 6.1 Write failing tests for `seedSampleData`:
  - 8 books, with every category having at least one
  - "The Pragmatic Programmer" is present
  - copies are between 1 and 20, and title and author are unique when spaces are trimmed and capital letters ignored
  - members M-0001 to M-0003 are all Active, with unique emails
  - exactly 1 librarian
  - the next member number is M-0004

  Verify that the tests fail.
- [x] 6.2 Implement `seedSampleData(Library, FixedClock)` in `lib/data/sample_data.dart`, inserting through the repositories. Verify that the 6.1 tests pass.

## 7. App shell (UI)

- [x] 7.1 Write the `main()` wiring: `SystemClock` set to the device date, the in-memory repositories, `Library`, the seed and `Session`, passed into `AppShell`. Verify that `flutter run` (or `flutter build macos --debug`) starts without errors.
- [x] 7.2 Build the role switch (`lib/ui/role_switch.dart`) in the app bar, listing "Librarian (<name>)" and then "M-0001 <name>"… Add widget tests for:
  - the starting value is Librarian
  - every member is listed
  - picking M-0002 updates `Session`

  Verify that the widget tests pass.
- [x] 7.3 Build the role-based bottom navigation with placeholder screens (Librarian: Catalog, Members, Dashboard. Member: Catalog, My loans, My reservations, My fees). Add widget tests for:
  - the exact destinations for each role
  - switching from Librarian on Dashboard to M-0001 shows the Member navigation with Catalog selected

  Verify that the widget tests pass.
- [x] 7.4 Build the dev clock control (`lib/ui/clock_control.dart`), showing today as YYYY-MM-DD with a "+1 day" button. Add a widget test with a fixed start date of 2026-01-30 where three taps show 2026-02-02. Verify that the widget test passes.
- [x] 7.5 Add the `runGuarded(context, action)` helper (`lib/ui/rule_violation_display.dart`), which catches `RuleViolation` and shows its message word for word in a `SnackBar`. Add a widget test with an action that throws `RuleViolation('Your account is suspended')` and expects that exact text. Verify that the widget test passes.

## 8. Integration check

- [x] 8.1 Run `flutter analyze` and `flutter test`, and check that both are clean. Then launch the app and manually check every scenario in `specs/app-shell/spec.md`: the role switch, the navigation for each role, the clock control and the sample data counts.

## Workflow follow-up

- The developer reviews and commits. Then archive the change once every task is checked and `flutter test` passes.
