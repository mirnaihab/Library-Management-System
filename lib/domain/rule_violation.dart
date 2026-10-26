/// A broken rule. [message] is shown to the user word for word.
class RuleViolation implements Exception {
  RuleViolation(this.message);

  final String message;

  @override
  String toString() => message;
}
