# Library

A single-branch library where librarians manage the catalog and members, and members borrow, renew and reserve books.

## People

**Librarian**:
The person who manages the catalog and members, records returns and records payments.

**Member**:
A person registered with the library who may borrow, renew and reserve books.
_Avoid_: User, borrower, patron, account

**Member number**:
A member's identifier, in the form M-0001.

**Active**:
The status of a member who is allowed to borrow, renew and reserve. Used only for member status.

**Suspended**:
The status of a member blocked by a librarian from borrowing, renewing and reserving, for a stated reason. A suspended member may still return books.

## Catalog

**Catalog**:
All the books the library holds.

**Book**:
A title by an author in one category, which the library owns one or more copies of. Two books are the same if their title and author match, ignoring capital letters and surrounding spaces.
_Avoid_: Title, item

**Copies**:
How many interchangeable physical copies of a book the library owns. Individual copies are not told apart.

**Available copies**:
Copies minus open loans minus holds for that book.
_Avoid_: In stock, free copies

**Availability**:
A book's available copies out of its copies, written as "2 of 3 available".
_Avoid_: Stock

**Category**:
One of a fixed set of subjects a book belongs to: Fiction, Science, History, Technology, Children.

## Loans

**Loan**:
A member borrowing one copy of a book, from the borrow date until it is returned.
_Avoid_: Checkout, borrowing (as a noun)

**Open loan**:
A loan that has not been returned yet.
_Avoid_: Active loan, current loan

**Returned loan**:
A loan whose copy has come back, with the date of return.
_Avoid_: Closed loan

**Due date**:
The last day a loan may be returned without a fee.

**Due soon**:
An open loan whose due date is today or within the next 2 days.

**Overdue**:
An open loan whose due date is before today.

**Renewal**:
Moving an open loan's due date 14 days past its current due date.
_Avoid_: Extension

**Borrowing limit**:
The most open loans a member may have at once: 3.

## Fees

**Fee**:
A charge created when a loan is returned after its due date: 5 EGP per day late, capped at 50 EGP.
_Avoid_: Fine, penalty

**Days late**:
The number of calendar days between a loan's due date and its return date.

**Outstanding fees**:
The part of a member's fees not yet paid.
_Avoid_: Balance, fees owed, total owed, debt

**Payment**:
An amount the librarian records against a member's outstanding fees, paying off the oldest fees first.

## Reservations

**Reservation**:
A member's place in the queue for a book that has no available copies. A reservation is either waiting or on hold.
_Avoid_: Request, booking

**Queue**:
A book's reservations, in the order they were made.

**Waiting**:
A reservation that has no copy set aside yet.

**Hold**:
A copy set aside for the member at the front of a book's queue, until a pickup deadline. A reservation with a hold is "on hold".
_Avoid_: Held copy

**Pickup deadline**:
The last day a hold can be collected: the third day after the hold starts.

**Hold expiry**:
The end of a hold that was not collected by its pickup deadline. The reservation is removed and the copy passes on down the queue.
