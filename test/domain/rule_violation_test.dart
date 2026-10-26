import 'package:flutter_test/flutter_test.dart';
import 'package:library_management_system/domain/rule_violation.dart';

void main() {
  test('a RuleViolation carries its message', () {
    expect(
      () => throw RuleViolation('x'),
      throwsA(isA<RuleViolation>().having((e) => e.message, 'message', 'x')),
    );
  });
}
