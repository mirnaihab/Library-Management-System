import 'package:flutter/foundation.dart';

import '../domain/book.dart';
import '../domain/book_repository.dart';
import '../domain/catalog.dart';
import '../domain/clock.dart';
import '../domain/day.dart';
import '../domain/librarian.dart';
import '../domain/member.dart';
import '../domain/member_repository.dart';

/// The library service. Every public query sweeps first and never notifies;
/// every command sweeps and notifies listeners after its work (ADR 0003).
class Library extends ChangeNotifier {
  Library({
    required this.bookRepository,
    required this.memberRepository,
    required this._clock,
  });

  /// Exposed for seeding sample data; screens use the queries below.
  // TODO(Stories 1.2, 2.1): once seeding goes through the add-book and
  // register-member commands, make the repositories and the librarian setter
  // private so nothing can skip the sweep or the notification.
  final BookRepository bookRepository;
  final MemberRepository memberRepository;
  final SystemClock _clock;

  /// Set once when seeding sample data.
  set librarian(Librarian? librarian) => _librarian = librarian;
  Librarian? _librarian;

  Day get today {
    sweep();
    return _clock.today;
  }

  Librarian? get librarian {
    sweep();
    return _librarian;
  }

  List<Book> get books {
    sweep();
    return bookRepository.all();
  }

  /// Every book with its available copies, sorted by title.
  List<CatalogEntry> get catalog {
    sweep();
    return catalogOf(bookRepository.all());
  }

  List<Member> get members {
    sweep();
    return memberRepository.all();
  }

  /// Sweeps after moving the day, so holds that expire on the new day are
  /// settled before listeners are told (ADR 0003).
  void advanceClock() {
    _clock.advance();
    sweep();
    notifyListeners();
  }

  /// The hold-expiry sweep (Story 6.3). Does nothing until then.
  @protected
  void sweep() {}
}
