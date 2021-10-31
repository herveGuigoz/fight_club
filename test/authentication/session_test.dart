import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Session', () {
    test('copyWith return new instance', () {
      const sessionA = Session();
      final sessionB = sessionA.copyWith(characters: [Character()]);
      final sessionC = sessionB.copyWith();
      expect(sessionB.characters, isNotEmpty);
      expect(sessionC.characters, isNotEmpty);
    });
    test('override toString()', () {
      expect(const Session().toString(), 'Session(characters: [])');
    });

    test('override operator ==', () {
      const sessionA = Session();
      final sessionB = Session(characters: [Character()]);
      expect(sessionA != sessionB, isTrue);
      expect(sessionA.hashCode != sessionB.hashCode, isTrue);
    });
  });
}
