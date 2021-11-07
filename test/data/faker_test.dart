import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Faker', () {
    test('generate random Fight', () {
      final fightA = Faker.fight();
      final fightB = Faker.fight();
      expect(fightA, isA<Fight>());
      expect(fightB, isA<Fight>());
      expect(fightA != fightB, isTrue);
    });

    test('generate random Character', () {
      final character = Faker.character(maxFightsCount: 10);
      expect(character, isA<Character>());
    });

    test('generate list of Character', () {
      final characters = Faker.characters(2);
      expect(characters.length, equals(2));
    });
  });
}
