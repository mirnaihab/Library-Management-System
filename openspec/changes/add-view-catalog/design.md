# Design

## Context

The foundation (`openspec/specs/app-shell`) gives `Library` a `books` query that returns the repository's books in insertion order. `AppShell` shows a `PlaceholderScreen` for every destination, including Catalog. `Book` stores only its `copies` count (ADR 0002). Loan and Hold don't exist yet. ADR 0003 now says queries never notify, and `advanceClock()` sweeps after moving the day. The code still sweeps before. Requirements are in `specs/catalog/spec.md`.

## Goals / Non-Goals

**Goals:**
- The sort order and available copies are plain Dart in `lib/domain/`, unit tested without widgets.
- Stories 3.1 and 6.2 change availability in one place, and Story 1.5 filters the same catalog query.

**Non-Goals:**
- No new entity or repository. The catalog is a view over the books.
- No caching or stored availability (ADR 0002).

## Decisions

### A catalog entry is a book plus its available copies

`lib/domain/catalog.dart` adds `CatalogEntry` (`book`, `availableCopies`) and a pure function `catalogOf(List<Book> books)`. The function returns one entry per book, sorted.
- **Available copies** are `book.copies` for now. Story 3.1 adds an open-loans parameter and Story 6.2 a holds parameter, and both are subtracted here.
- **Sorting** compares `title.trim().toLowerCase()`, then `author.trim().toLowerCase()`. These are Dart's plain string comparisons: no articles are moved and no locale-aware collation is used.

*Alternative:* an `availableCopies` getter on `Book`. Rejected, because the book would then need to know about loans and holds, and ADR 0002 keeps `Book` to its copies count.
*Alternative:* sorting in the widget. Rejected, because Story 1.5's search and filters would then each need their own copy of the order. (Settled in the Story 1.1 grilling, Q5.)

### `Library.catalog` query

`List<CatalogEntry> get catalog` runs `sweep()`, then returns `catalogOf(bookRepository.all())`. It is a query, so it never notifies (ADR 0003). The existing `books` query stays for the shell and seeding tests.

### Catalog screen

`lib/ui/catalog/catalog_screen.dart` has a `CatalogScreen(library)` that listens to `library` through `ListenableBuilder`.
- With no entries it shows a centered "The catalog is empty".
- Otherwise each row is a `ListTile`. The title is the book title and the subtitle is "author · category display name". The trailing text comes from `availabilityText(entry)`, which returns "<available> of <copies> available".

The screen has no actions for either role.

### Wiring the screen into the shell

Each `_Destination` record in `AppShell` gains a builder for its screen. Catalog builds `CatalogScreen` for both roles, and the other destinations keep `PlaceholderScreen`. The shell already resets to index 0 (Catalog) when the role changes.

*Alternative:* switching on the label string. Rejected, because a misspelled label would quietly show a placeholder.

### `advanceClock()` sweeps after moving the day

The order becomes: advance the clock, `sweep()`, `notifyListeners()`. A test double records the clock's today each time it sweeps, and checks that the sweep sees the new day.

## Risks / Trade-offs

- [The "2 of 3 available" example can't be reached until loans exist] → The scenarios cover "N of N". Story 3.1's tasks add the "2 of 3" test when `catalogOf` starts subtracting open loans.
- [Plain string comparison orders accented and non-Latin titles by character code, so "Émile" sorts after "Zoo"] → Accepted. Every story uses English titles, and locale-aware collation would need `intl`, which ADR 0003 rules out.
- [The empty catalog can't be reached in the running app before Story 1.4] → It is covered by a widget test on a library built without sample data.
- [`catalog` copies and sorts every book on each build] → Fine for an in-memory library of tens of books.
