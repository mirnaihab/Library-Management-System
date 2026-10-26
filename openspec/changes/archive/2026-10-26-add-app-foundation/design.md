# Design

## Context

`lib/main.dart` is the Flutter template's "Hello World". There is no other code and there are no tests. `pubspec.yaml` has no dependencies beyond Flutter. The architecture, vocabulary and the domain decisions that are hard to undo are already settled in ADRs 0001–0004 and `GLOSSARY.md`. This design applies them to the foundation. The requirements are in `specs/app-shell/spec.md`.

## Goals / Non-Goals

**Goals:**
- Each later story adds only its own entities, rules, repository methods and screens. It doesn't change the shell, the clock or how errors are shown.
- Domain and application code can be tested with `flutter test` without building any widgets, and domain code imports nothing from Flutter (tests may use `flutter_test`).

**Non-Goals:**
- No entities beyond Book, Member and Librarian. In particular, there are no Loan, Fee or Reservation types yet.
- No navigation package and no routes. Switching between bottom-navigation tabs is enough.

## Decisions

### Layout (ADR 0003)

```
lib/
  domain/        day.dart, clock.dart, rule_violation.dart,
                 book.dart, category.dart, member.dart, librarian.dart,
                 book_repository.dart, member_repository.dart
  data/          in_memory_book_repository.dart, in_memory_member_repository.dart,
                 sample_data.dart
  application/   library.dart (service + ChangeNotifier), session.dart (role)
  ui/            app_shell.dart, role_switch.dart, clock_control.dart,
                 rule_violation_display.dart, <screen>/placeholder screens
test/            mirrors lib/
```

### `Day` instead of `DateTime`

`Day` is a small value type made of year, month and day. It provides `==`, ordering, `addDays(n)` and `daysUntil(other)`. It's built from a UTC `DateTime` internally, so a daylight-saving change can't shift a day boundary. *Alternative:* plain `DateTime` truncated to midnight. Rejected, because a `DateTime` that still has a time in it could leak into comparisons, which is exactly the off-by-one bug the stories warn about.

### `Clock`

`abstract class Clock { Day get today; }` has two implementations:
- `SystemClock`: starts at the device date and keeps an `offsetDays` that the dev control increases.
- `FixedClock`: a settable `Day`, used in tests and when seeding sample data.

Only the application layer and the sample data hold a `Clock`. Domain functions take `Day today` as a parameter, so they never depend on a clock.
*Alternative:* domain classes call `clock.today` themselves. Rejected, because passing the day in keeps the domain functions pure and their tests one line long.

### `RuleViolation`

`class RuleViolation implements Exception { final String message; }`. Exact texts live in the code that throws them, quoted from `docs/stories.md`. The UI catches it in one helper, `runGuarded(context, action)`, which shows a `SnackBar`. Form fields check their own input and show it with `errorText`. *Alternative:* a sealed `Result` type, rejected in the grilling session (Q8).

### Repositories

`BookRepository` and `MemberRepository` are interfaces in `domain/`, with `InMemory…` versions in `data/` backed by `Map`s that keep insertion order. They store and fetch data only, with no rules. Each later story adds the methods it needs.
- **Book IDs** are internal sequential strings that are never shown.
- **Member numbers** come from `MemberRepository.nextMemberNumber()`, which starts after the highest existing number, so the sample data ends at M-0003 and the next is M-0004.

### `Library` (application service)

`Library extends ChangeNotifier` takes the repositories and the `Clock`.
- **Commands** run `_sweep()` first, then the work, then `notifyListeners()`.
- **Queries** run `_sweep()` first, then read.
- `_sweep()` does nothing until Story 6.3, but it's placed now so that no later story can forget it (ADR 0003).
- `advanceClock()` moves the `SystemClock` forward and notifies listeners.

*Alternative:* one service per epic. That's deferred: start with one `Library` and split it only if it grows unwieldy.

### Session and role switch

`Session` is a separate small `ChangeNotifier` that holds `Role`, either `LibrarianRole` or `MemberRole(memberNumber)`. Who is using the app isn't library data, so it doesn't belong in `Library`. `AppShell` listens to both notifiers through `ListenableBuilder`. The bottom navigation is rebuilt from the role, and the selected tab resets to 0 whenever the role changes.

### Sample data

`seedSampleData(Library library, FixedClock clock)` runs on a `FixedClock` so that later stories can seed past events (an overdue loan, a hold) by moving the clock backwards. In this change it inserts 8 books, 3 members and 1 librarian straight into the repositories, because the add-book and register-member commands arrive in Stories 1.2 and 2.1. Once they exist, those stories switch seeding over to the commands (Q25).

## Risks / Trade-offs

- [Seeding directly bypasses validation until Stories 1.2 and 2.1] → A sample-data test checks that the data is unique and that copies are between 1 and 20. Stories 1.2 and 2.1 each include a task to seed through their new command.
- [One `Library` class could grow large across 7 epics] → Its public methods stay thin and the rules live in `domain/`. If it passes about 400 lines, split it per epic behind the same notifier.
- [`SystemClock` reads the device date only once, at launch] → Accepted. If the app is left running past midnight, today won't change until the next launch or a dev-clock press. That's fine for an in-memory demo.
