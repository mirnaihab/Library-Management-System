# Spec Delta

## Purpose

Shows the library's books and how many copies of each are available, so the librarian and members know what the library has.

## ADDED Requirements

### Requirement: Catalog lists every book
The catalog SHALL list every book in the library, showing its title, author, category and availability. The librarian and members SHALL see the same catalog.

#### Scenario: Every sample book is listed
- **WHEN** the app starts with the sample data and the user opens Catalog
- **THEN** all 8 books are listed, each with its title, author and category

#### Scenario: Category shown by name
- **WHEN** the catalog lists "The Pragmatic Programmer"
- **THEN** its category is shown as "Technology"

#### Scenario: Members see the same catalog
- **WHEN** the role is switched from Librarian to "M-0001" and the user opens Catalog
- **THEN** the same books are listed in the same order with the same availability

### Requirement: Availability is shown as available out of copies
Each book's availability SHALL be shown as "<available> of <copies> available", where available copies are the copies minus open loans minus holds for that book. The same format SHALL be used when every copy, one copy or no copy is available.

#### Scenario: All copies available
- **WHEN** a book has 3 copies, no open loans and no holds
- **THEN** its availability reads "3 of 3 available"

#### Scenario: Single copy
- **WHEN** a book has 1 copy, no open loans and no holds
- **THEN** its availability reads "1 of 1 available"

### Requirement: Catalog is sorted by title
The catalog SHALL list books by title from A to Z, ignoring capital letters and surrounding spaces. Leading words such as "The" or "A" SHALL count as part of the title. Books with the same title SHALL be ordered by author, compared the same way.

#### Scenario: Sample books sorted A–Z
- **WHEN** the app starts with the sample data
- **THEN** the catalog lists "A Brief History of Time", "Clean Code", "Cosmos", "Dune", "The Guns of August", "The Pragmatic Programmer", "The Very Hungry Caterpillar", "To Kill a Mockingbird", in that order

#### Scenario: Capital letters ignored
- **WHEN** the catalog holds "cosmos" and "Clean Code"
- **THEN** "Clean Code" is listed before "cosmos"

#### Scenario: Same title ordered by author
- **WHEN** the catalog holds "Dune" by "Frank Herbert" and "Dune" by "Brian Herbert"
- **THEN** the book by "Brian Herbert" is listed first

### Requirement: Empty catalog message
When the library has no books, the catalog SHALL show "The catalog is empty" instead of a list.

#### Scenario: No books
- **WHEN** the library has no books and the user opens Catalog
- **THEN** the screen shows exactly "The catalog is empty"
