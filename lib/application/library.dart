import 'package:flutter/foundation.dart';

import '../domain/book.dart';
import '../domain/book_repository.dart';
import '../domain/clock.dart';
import '../domain/day.dart';
import '../domain/librarian.dart';
import '../domain/member.dart';
import '../domain/member_repository.dart';

/// The library service. Every public query sweeps first; every command sweeps
/// first and notifies listeners after its work (ADR 0003).
class Library extends ChangeNotifier {
  Library({
    required this.bookRepository,
    required this.memberRepository,
    required this._clock,
  });

  /// Exposed for seeding sample data; screens use the queries below.
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

  List<Member> get members {
    sweep();
    return memberRepository.all();
  }

  void advanceClock() {
    sweep();
    _clock.advance();
    notifyListeners();
  }

  /// The hold-expiry sweep (Story 6.3). Does nothing until then.
  @protected
  void sweep() {}
}
