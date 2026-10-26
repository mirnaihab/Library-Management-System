# Tasks

## 1. Catalog entries (domain)

- [x] 1.1 Write failing tests for `catalogOf` in `test/domain/catalog_test.dart`:
  - one entry per book
  - available copies equal copies when there are no loans or holds (3 copies → 3)
  - sorted by title ignoring capital letters ("Clean Code" before "cosmos") and surrounding spaces
  - leading "The" kept in place ("Dune" before "The Guns of August")
  - same title ordered by author ("Dune" by Brian Herbert before "Dune" by Frank Herbert)
  - an empty book list gives an empty catalog

  Verify that `flutter test test/domain/catalog_test.dart` fails.
- [x] 1.2 Implement `CatalogEntry` and `catalogOf` in `lib/domain/catalog.dart`, with no Flutter imports. Verify that the 1.1 tests pass.

## 2. Library service (application)

- [x] 2.1 Write failing tests in `test/application/library_test.dart`:
  - `catalog` sweeps before reading the books, checked with the existing logging test doubles
  - `catalog` on the sample data lists the 8 titles in the spec's A–Z order
  - `catalog` doesn't notify listeners

  Verify that the tests fail.
- [x] 2.2 Add the `catalog` query to `Library`. Verify that the 2.1 tests pass.
- [x] 2.3 Write a failing test that `advanceClock()` sweeps after moving the day: a test double records the clock's today on each sweep, and from 2026-01-10 the sweep sees 2026-01-11. Verify that it fails against the current order (sweep before advance).
- [x] 2.4 Reorder `advanceClock()` to advance, sweep, then notify (ADR 0003). Verify that the 2.3 test and the existing "notifies once" and "every public query and command sweeps" tests pass.

## 3. Catalog screen (UI)

- [x] 3.1 Build `CatalogScreen` in `lib/ui/catalog/catalog_screen.dart`, with `availabilityText(entry)` returning "<available> of <copies> available". Add widget tests in `test/ui/catalog_screen_test.dart`:
  - on the sample data, 8 rows in the spec's A–Z order
  - "The Pragmatic Programmer" shows "Andrew Hunt · Technology" and "3 of 3 available"
  - a 1-copy book shows "1 of 1 available"
  - an empty library (no seed) shows exactly "The catalog is empty"

  Verify that the widget tests pass.
- [x] 3.2 Give each `AppShell` destination a screen builder. Catalog builds `CatalogScreen` for both roles, and the rest keep `PlaceholderScreen`. Add widget tests:
  - the Librarian's Catalog shows the book list
  - after switching to M-0001, the same titles appear in the same order

  Verify that these and the existing `app_shell_test.dart` tests pass.

## 4. Integration check

- [x] 4.1 Run `flutter analyze` and `flutter test`, and check that both are clean. Then launch the app and check every scenario in `specs/catalog/spec.md` by hand, except "No books", which only the widget test can reach before Story 1.4. Check the catalog as both Librarian and M-0001.

## Workflow follow-up

- The developer reviews and commits. Then archive the change once every task is checked and `flutter test` passes.
