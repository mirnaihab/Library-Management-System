# app-shell Specification

## Purpose

Sets up the frame every story runs inside: who is using the app, what day it is, how rule violations reach the user, how each role moves between screens, and the data the app starts with.

## Requirements

### Requirement: Role switch
The app SHALL show a role switch at the top of every screen, listing *Librarian* followed by one entry per member, shown as member number and name. Choosing *Librarian* puts the app in Librarian mode. Choosing a member puts it in Member mode, acting as that member. There SHALL be no login or password.

#### Scenario: Switch lists the librarian and every member
- **WHEN** the app starts with the sample data
- **THEN** the role switch lists "Librarian", then "M-0001", "M-0002" and "M-0003" with each member's name

#### Scenario: App starts as the librarian
- **WHEN** the app starts
- **THEN** the role switch shows "Librarian" and the Librarian navigation is shown

#### Scenario: Choosing a member enters Member mode as that member
- **WHEN** the user picks "M-0002" in the role switch
- **THEN** the Member navigation is shown and the app acts as member M-0002

### Requirement: Role-based navigation
Each role SHALL have its own bottom navigation. Librarian: Catalog, Members, Dashboard. Member: Catalog, My loans, My reservations, My fees. Changing the role SHALL replace the navigation and open that role's first destination.

#### Scenario: Librarian destinations
- **WHEN** the role is Librarian
- **THEN** the bottom navigation shows exactly Catalog, Members and Dashboard

#### Scenario: Member destinations
- **WHEN** the role is a member
- **THEN** the bottom navigation shows exactly Catalog, My loans, My reservations and My fees

#### Scenario: Changing role resets the destination
- **WHEN** the librarian is on Dashboard and the user picks "M-0001"
- **THEN** the Member navigation is shown with Catalog selected

### Requirement: Today comes from the clock
The app SHALL get "today" only from its clock, as a calendar day with no time of day. When the app launches, today SHALL be the device's current date. Every date rule SHALL count whole calendar days.

#### Scenario: Launch uses the device date
- **WHEN** the app launches on a device whose date is 2026-10-26
- **THEN** the app's today is 2026-10-26

#### Scenario: Time of day is ignored
- **WHEN** the device time is 2026-10-26 23:59
- **THEN** the app's today is 2026-10-26, the same as at 00:00 that day

#### Scenario: Day differences count calendar days
- **WHEN** one day is 2026-01-10 and another is 2026-01-13
- **THEN** the difference between them is 3 days

### Requirement: Dev clock control
The app shell SHALL show today's date and a control that moves today forward by one day. Moving the clock SHALL update every screen immediately.

#### Scenario: Advancing one day
- **WHEN** today is 2026-01-10 and the user presses "+1 day"
- **THEN** the shell shows today as 2026-01-11

#### Scenario: Advancing several times
- **WHEN** today is 2026-01-30 and the user presses "+1 day" three times
- **THEN** the shell shows today as 2026-02-02

### Requirement: Rule violations are shown to the user
When an action breaks a rule, the app SHALL leave all data unchanged and show the violation's message to the user, word for word. On a screen it is shown as a brief message bar. On a form it is shown next to the field it concerns.

#### Scenario: Violation on a screen
- **WHEN** an action on a screen is rejected with the message "Your account is suspended"
- **THEN** a message bar shows exactly "Your account is suspended" and no data has changed

#### Scenario: Violation on a form
- **WHEN** a form is submitted with a field the rule rejects
- **THEN** the message appears next to that field and the form stays open with the values entered

### Requirement: Data is held in memory
All library data SHALL be held in memory only. Restarting the app SHALL discard every change and start again from the sample data.

#### Scenario: Restart restores sample data
- **WHEN** data changes during a session and the app is restarted
- **THEN** the app shows only the sample data again

### Requirement: Sample books
The app SHALL start with 8 books that cover all 5 categories (Fiction, Science, History, Technology, Children), each with between 1 and 20 copies and a unique title and author. One of them SHALL be "The Pragmatic Programmer".

#### Scenario: Eight books across every category
- **WHEN** the app starts
- **THEN** there are 8 books, and each of Fiction, Science, History, Technology and Children has at least one

#### Scenario: Searchable sample title
- **WHEN** the app starts
- **THEN** a book titled "The Pragmatic Programmer" is in the catalog

### Requirement: Sample people
The app SHALL start with 3 members, numbered M-0001, M-0002 and M-0003, each Active with a unique email, and with 1 librarian. The next member registered SHALL get M-0004.

#### Scenario: Three active members
- **WHEN** the app starts
- **THEN** members M-0001, M-0002 and M-0003 exist and all are Active

#### Scenario: Member numbers continue after the sample data
- **WHEN** the app starts and a fourth member number is issued
- **THEN** it is M-0004

#### Scenario: One librarian
- **WHEN** the app starts
- **THEN** exactly one librarian exists, and their name is shown in the role switch next to "Librarian"
