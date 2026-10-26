# Library Management System: user stories

Below is a fuller library system than the loans app: librarians manage the catalog and the members, and members borrow, renew and reserve books. Every acceptance criterion is meant to be specific enough to turn directly into a test.

## Global rules (apply to every story)

- **Users:** one app with two roles, Librarian and Member. A role switch at the top of the screen chooses who is using the app. There is no real login.
- **Data:** stored in memory and lost on restart. Start with sample data: at least 8 books, 3 members and 1 librarian.
- **Dates:** "today" comes from an injectable clock, so tests can control time. All rules count calendar days.
- **Money:** whole EGP amounts only.
- **Errors:** every rule violation shows a clear message to the user (the exact texts are given in the ACs).
- **Out of scope:** real login and passwords, a database, payments, notifications, multiple library branches.

---

## Epic 1: Catalog (Librarian)

### Story 1.1: View the catalog

> As a user, I want to see all books, so that I know what the library has.

1. The catalog lists every book with title, author, category and availability, e.g. "2 of 3 available".
2. Books are sorted by title A–Z.
3. With no books, the screen shows "The catalog is empty".

### Story 1.2: Add a book

> As a librarian, I want to add a book, so that members can borrow it.

1. Required fields: title, author, category, number of copies.
2. Categories come from a fixed list: Fiction, Science, History, Technology, Children.
3. The number of copies must be a whole number from 1 to 20. Anything else shows "Copies must be between 1 and 20".
4. A missing title or author shows "Title and author are required".
5. Adding the same title by the same author again (ignoring capital letters) shows "This book already exists".
6. A new book appears in the catalog immediately, with all copies available.

### Story 1.3: Edit a book

> As a librarian, I want to correct a book's details, so that the catalog stays accurate.

1. The librarian can change the title, author, category and number of copies.
2. The same validation rules as Story 1.2 apply.
3. Copies cannot go below the number currently on loan: "3 copies are on loan; cannot reduce below 3".

### Story 1.4: Remove a book

> As a librarian, I want to remove a book, so that lost or damaged books disappear from the catalog.

1. The app asks for confirmation before removing.
2. A book with any copy on loan cannot be removed: "Cannot remove: copies are on loan".
3. Removing a book also cancels all of its reservations (see Epic 6).

### Story 1.5: Search and filter

> As a user, I want to search the catalog, so that I find a book quickly.

1. Typing in the search box filters by title or author, ignores capital letters, and matches part of a word ("prag" finds "The Pragmatic Programmer").
2. A category filter shows only books in that category, and it combines with the search.
3. An "Available only" toggle hides books with 0 available copies.
4. No results shows "No books match your search".
5. Clearing the search and filters shows the full catalog again.

---

## Epic 2: Members (Librarian)

### Story 2.1: Register a member

> As a librarian, I want to register a member, so that they can borrow books.

1. Required fields: full name and email.
2. The email must contain "@" and a "." after it: "Enter a valid email".
3. Emails are unique, ignoring capital letters: "A member with this email already exists".
4. Each new member gets a member number in the format M-0001, M-0002, and so on.
5. New members are Active.

### Story 2.2: View members

> As a librarian, I want to see all members, so that I can manage them.

1. The list shows member number, name, status (Active/Suspended), books on loan, and fees owed.
2. Search works by name or member number.

### Story 2.3: Suspend and reactivate

> As a librarian, I want to suspend a member, so that they can't borrow until an issue is solved.

1. The librarian can suspend an Active member and must enter a reason.
2. A suspended member cannot borrow, renew or reserve: "Your account is suspended".
3. A suspended member can still return books.
4. The librarian can reactivate a suspended member.

---

## Epic 3: Borrowing (Member)

### Story 3.1: Borrow a book

> As a member, I want to borrow a book, so that I can read it at home.

1. An available book has a Borrow button.
2. Borrowing creates a loan that is due 14 days later.
3. Availability goes down by 1 immediately.
4. With no copies left: "No copies available" (the member can reserve instead; see Epic 6).
5. The member already has this book: "You already have this book".
6. A suspended member: "Your account is suspended".

### Story 3.2: Borrowing limit

> As a librarian, I want to limit loans per member, so that books stay available for everyone.

1. A member can have at most 3 active loans.
2. A 4th borrow is rejected: "Borrowing limit reached (3 books)".
3. Returning a book frees a slot.
4. The member's screen shows "2 of 3 books borrowed".

### Story 3.3: My loans

> As a member, I want to see my loans, so that I return them on time.

1. The list shows title, borrow date and due date, with the earliest due date first.
2. A loan due within the next 2 days is labelled "Due soon".
3. A loan past its due date is labelled "Overdue (N days)".
4. With no loans: "You have no books on loan".

### Story 3.4: Renew a loan

> As a member, I want to renew a loan, so that I can keep a book longer.

1. Renewing extends the due date by 14 days from the current due date.
2. A loan can be renewed at most 2 times: "Renewal limit reached".
3. An overdue loan cannot be renewed: "Overdue loans cannot be renewed".
4. A book that someone else has reserved cannot be renewed: "This book is reserved by another member".

---

## Epic 4: Returns (Librarian)

### Story 4.1: Return a book

> As a librarian, I want to record a return, so that the book becomes available again.

1. The librarian picks the member, then the loan, then Return.
2. The loan is closed with today's date.
3. If the book has reservations, the copy goes to the reservation queue (Story 6.2). Otherwise, availability goes up by 1.
4. A late return creates a fee (Story 5.1), and the confirmation shows it: "Returned 3 days late. Fee: 15 EGP".

---

## Epic 5: Fees

### Story 5.1: Late fee

> As a librarian, I want late returns to create a fee, so that members return books on time.

1. The fee is 5 EGP per day late. Days late = return date − due date.
2. A single fee is capped at 50 EGP.
3. Returning on the due date or earlier creates no fee.
4. Examples that must work: 1 day late = 5 EGP; 10 days = 50; 15 days = 50.

### Story 5.2: Fee blocks borrowing

> As a librarian, I want members with high fees blocked, so that fees get paid.

1. A member who owes more than 20 EGP cannot borrow or renew: "Please pay outstanding fees first (25 EGP)".
2. Owing exactly 20 EGP is still allowed.
3. Returning books is always allowed.

### Story 5.3: Pay fees

> As a librarian, I want to record a payment, so that the member's balance is updated.

1. The member's page shows a list of fees (book, days late, amount) and the total.
2. The librarian records a payment amount. It must be between 1 and the total owed: "Amount must be between 1 and 25 EGP".
3. A payment pays off the oldest fees first. Partial payments are allowed.
4. The total updates immediately.

---

## Epic 6: Reservations

### Story 6.1: Reserve a book

> As a member, I want to reserve an unavailable book, so that I get it when it comes back.

1. Reserve appears only when a book has 0 available copies.
2. A member cannot reserve a book they currently have: "You already have this book".
3. A member cannot reserve the same book twice: "You already reserved this book".
4. A member can hold at most 2 active reservations: "Reservation limit reached (2)".
5. Reservations do not count toward the borrowing limit of 3.
6. The member sees their position in the queue, e.g. "Position 2 of 3".

### Story 6.2: Hold on return

> As a member, I want a returned copy held for me, so that nobody else takes it.

1. When a copy of a reserved book is returned, it becomes On hold for the member first in the queue.
2. A held copy doesn't count as available, so other members see "No copies available".
3. The member with the hold sees "Ready for pickup until <date>".
4. Borrowing the held book turns the hold into a normal loan and removes the reservation.

### Story 6.3: Hold expiry

> As a librarian, I want uncollected holds to expire, so that books don't sit unused.

1. A hold lasts 3 days (pickup is allowed until the end of the 3rd day after the return).
2. After that, the hold expires and the reservation is removed.
3. The copy goes to the next member in the queue, or becomes available if the queue is empty.
4. Expiry is checked whenever the app reads data, so no background timer is needed.

### Story 6.4: Cancel a reservation

> As a member, I want to cancel a reservation, so that I free my place in the queue.

1. A member can cancel any of their reservations.
2. If the cancelled reservation had a hold, the copy moves to the next member in the queue (or becomes available).
3. Everyone behind them in the queue moves up one position.

---

## Epic 7: Dashboard (Librarian)

### Story 7.1: Library overview

> As a librarian, I want a summary screen, so that I see what needs attention.

1. Shows: total books, total copies, copies on loan, overdue loans, and total unpaid fees.
2. Lists overdue loans (member, book, days overdue), most overdue first.
3. Lists holds that are ready for pickup, with their expiry dates.
4. All numbers update after any borrow, return or payment.

---

## Suggested order

| Round | Stories | Why |
|---|---|---|
| 1 | 1.1 → 1.2 → 2.1 | Builds the basic data |
| 2 | 3.1 → 4.1 → 3.3 | The core loan loop |
| 3 | 3.2 → 5.1 → 5.2 → 5.3 | Rules with many edge cases (great for TDD) |
| 4 | 1.3 → 1.4 → 1.5 → 2.2 → 2.3 | Management features |
| 5 | 3.4 → 6.1 → 6.2 → 6.3 → 6.4 | The hardest logic, where stories interact |
| 6 | 7.1 | Ties everything together |

## Where each skill pays off most

- **/grill-me:** Epic 6 and Story 3.4. They interact with other stories ("what if someone reserves a book I'm renewing?").
- **/tdd:** Epic 5 (fee calculation and the oldest-fees-first payment rule) and Story 6.3 (expiry dates).
- **$claude-delegate:** mechanical tasks like sample data, form validation messages, or the dashboard layout.
- **Debate review:** Epic 6. Queue logic is where subtle bugs hide.
- **/diagnose:** whenever a "days late" or hold-expiry date is off by one.

Good luck. If a story's AC reads as unclear once you start building, ask me about it. Spotting that kind of gap is part of what grill-me should teach you.
