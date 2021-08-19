import 'package:insightme/Core/functions/misc.dart';
import 'package:test/test.dart';

void main() {
  group('getFirstLetter', () {
    test('Hello->H', () {
      final firstChar = getFirstLetter('Hello');
      expect(firstChar, 'H');
    });
    test('-> ', () {
      final firstChar = getFirstLetter('');
      expect(firstChar, ' ');
    });
    test('hello->h', () {
      final firstChar = getFirstLetter('hello');
      expect(firstChar, 'h');
    });
    test('o->o', () {
      final firstChar = getFirstLetter('o');
      expect(firstChar, 'o');
    });
    test('123->1', () {
      final firstChar = getFirstLetter('123');
      expect(firstChar, '1');
    });
  });
}
