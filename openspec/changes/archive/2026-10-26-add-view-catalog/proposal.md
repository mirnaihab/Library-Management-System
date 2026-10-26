# Proposal

## Why

Both roles open the app on Catalog, which is still an empty placeholder. This change implements **Story 1.1: View the catalog** from `docs/stories.md`, so that the librarian and every member can see what the library holds. It also sets up the catalog query and the availability calculation that Stories 1.2–1.5, 3.1 and 6.2 build on.

## What Changes

- Add an availability calculation in the domain: a book's available copies out of its copies. ADR 0002 says available copies are always calculated, never stored. No loans or holds exist yet, so available copies equal copies until Stories 3.1 and 6.2 subtract them.
- Add a catalog query to the library service. It returns every book with its availability, sorted by title A–Z, ignoring capital letters and surrounding spaces. Books with the same title are ordered by author.
- Replace the Catalog placeholder with the catalog screen, shared by both roles. Each row shows the title, "author · category" and "N of M available". With no books, the screen shows "The catalog is empty".
- Change `advanceClock()` to sweep after moving the day rather than before, as ADR 0003 now requires ("queries never notify; only commands and the clock notify").

## Capabilities

### New Capabilities

- `catalog`: listing the library's books with their availability. Stories 1.2–1.5 extend it with adding, editing, removing, searching and filtering books.

### Modified Capabilities

None. The `advanceClock()` reorder changes no behavior a user can see until the sweep does something in Story 6.3.

## Out of scope

- Adding, editing and removing books (Stories 1.2–1.4). The catalog has no actions in this change, for either role.
- Search, category filter and the "Available only" toggle (Story 1.5).
- Borrow and Reserve buttons (Stories 3.1 and 6.1).
- Subtracting open loans and holds from available copies (Stories 3.1 and 6.2). This change shows only "N of N available", so the "2 of 3 available" case gets its test in Story 3.1.
- Language-aware sorting of non-English titles. Titles are compared letter by letter after ignoring capital letters.
- A way to reach the empty catalog in the running app. Nothing can remove a book until Story 1.4, so the empty state is covered only by a widget test.

## Impact

- **Code:** new domain code for availability and catalog ordering, a new `Library` query, a new catalog screen in `lib/ui/`, and `AppShell` showing that screen for the Catalog destination. `Library.advanceClock()` changes its sweep order.
- **Dependencies:** none added (ADR 0003).
- **Docs:** follows `GLOSSARY.md` (Availability, Available copies) and ADRs 0002 and 0003. No new ADR.
