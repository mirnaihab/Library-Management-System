# Proposal

## Why

Every story in `docs/stories.md` depends on the same groundwork: a way to choose who is using the app, an injectable "today", one shape for rule violations, in-memory repositories and starting sample data. Building these once, before any story, lets each later change implement only its own rules. It also puts the agreed architecture (ADR 0003) in place from the first commit. This change implements the **Global rules** section of `docs/stories.md`. It doesn't implement any numbered story.

## What Changes

- Replace the "Hello World" placeholder in `lib/main.dart` with the app shell.
- Add the layered folder structure: `lib/domain`, `lib/data`, `lib/application` and `lib/ui` (ADR 0003).
- Add a calendar-day value type and a `Clock` abstraction. The system clock starts on the device's real date, and a fixed clock is used in tests. Domain code never calls `DateTime.now()`.
- Add a single `RuleViolation(message)` error type that the UI shows to the user.
- Add the **Book**, **Member** and **Librarian** entities, repository interfaces for books and members, and in-memory implementations. Member numbers are issued in the form M-0001.
- Add the library service and one `ChangeNotifier` that announces a change after every command. Before each public command and query, the service calls a hold-expiry sweep, which does nothing until Epic 6.
- Add the app shell:
  - a role switch at the top, with *Librarian* plus one entry per member
  - a dev clock control that shows today and adds days
  - bottom navigation that changes with the role
  - an empty placeholder for each screen agreed for later stories
- Add sample data: 8 books covering all 5 categories, 3 members (M-0001 to M-0003) and 1 librarian.

## Capabilities

### New Capabilities

- `app-shell`: the role switch, the clock and its dev control, how rule violations reach the user, the role-based navigation and the starting sample data.

### Modified Capabilities

None. No specs exist yet.

## Out of scope

- All catalog behavior: viewing, adding, editing, removing and searching books (Stories 1.1–1.5). The Catalog screen is an empty placeholder.
- Registering, listing, suspending and reactivating members (Stories 2.1–2.3). This change seeds members but provides no screens for them.
- Loans, returns, fees, reservations and holds (Epics 3–6). The Loan, Fee and Reservation entities and their repositories arrive with the stories that first need them. The hold-expiry sweep does nothing until Story 6.3.
- The dashboard (Story 7.1).
- Sample loans, fees, queues, holds and suspended members. Each later story adds its own sample state through the library service when it lands. This change seeds only plain books and members.
- Real login, persistence, notifications and multiple branches (global out-of-scope list).

## Impact

- **Code:** `lib/main.dart` is replaced, and new folders are added under `lib/` and `test/`.
- **Dependencies:** none added. `pubspec.yaml` stays at Flutter only (ADR 0003).
- **Docs:** follows `GLOSSARY.md` and ADRs 0002–0004. No new ADR.
