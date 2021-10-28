import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Characters', () {
    group('attributes', () {
      final character = Character();
      final attributes = character.attributes;

      test('initial level is 1', () {
        expect(character.level, equals(1));
      });

      test('initial skills is 12', () {
        expect(character.skills, equals(12));
      });

      test('initial health is 10', () {
        expect(character.health.points, equals(10));
      });

      test('initial attack is 0', () {
        expect(character.attack.points, equals(0));
      });

      test('initial defense is 0', () {
        expect(character.defense.points, equals(0));
      });

      test('initial magik is 0', () {
        expect(character.magik.points, equals(0));
      });

      test('has Health attribute', () {
        expect(attributes.any((attribute) => attribute is Health), isTrue);
      });

      test('has Attack attribute', () {
        expect(attributes.any((attribute) => attribute is Attack), isTrue);
      });

      test('has Defense attribute', () {
        expect(attributes.any((attribute) => attribute is Defense), isTrue);
      });

      test('has Magik attribute', () {
        expect(attributes.any((attribute) => attribute is Magik), isTrue);
      });
    });

    group('serialization', () {
      const codec = CharacterCodec();

      final json = {
        'level': 7,
        'skills': 0,
        'health': 10,
        'attack': 9,
        'defense': 4,
        'magik': 8,
      };

      test('CharacterCodec decode correct value', () {
        final character = codec.fromMap(json);

        expect(character.level, equals(7));
        expect(character.skills, equals(0));
        expect(character.health.points, equals(10));
        expect(character.attack.points, equals(9));
        expect(character.defense.points, equals(4));
        expect(character.magik.points, equals(8));
      });

      test('CharacterCodec format correct json', () {
        final character = Character(
          level: 7,
          skills: 0,
          health: 10,
          attack: 9,
          defense: 4,
          magik: 8,
        );

        expect(codec.toMap(character), equals(json));
      });
    });

    group('equality', () {
      test('unit are equals', () {
        final characterA = Character();
        final characterB = Character();
        expect(characterA == characterB, isTrue);
        expect(characterA.hashCode == characterA.hashCode, isTrue);
      });

      test('unit are not equals', () {
        final characterA = Character(skills: 21);
        final characterB = Character();
        expect(characterA == characterB, isFalse);
      });

      test('list are equals', () {
        final listA = [Character(attack: 1), Character(attack: 2)];
        final listB = [Character(attack: 1), Character(attack: 2)];
        expect(listEquals(listA, listB), isTrue);
      });

      test('list are not equals', () {
        final listA = [Character(attack: 1), Character(attack: 2)];
        final listB = [Character(attack: 3), Character(attack: 4)];
        expect(listEquals(listA, listB), isFalse);
      });
    });

    group('copyWith', () {
      test('reference current attributes', () {
        final characterA = Character();
        final characterB = Character().copyWith();
        expect(characterA, equals(characterB));
      });
      test('reference new attributes', () {
        final character = Character().copyWith(
          level: 2,
          skills: 99,
          health: 12,
          attack: 1,
          defense: 1,
          magik: 1,
        );
        expect(character.level, equals(2));
        expect(character.skills, equals(99));
        expect(character.health.points, equals(12));
        expect(character.attack.points, equals(1));
        expect(character.defense.points, equals(1));
        expect(character.magik.points, equals(1));
      });
    });

    group('to string', () {
      test('reference skills, level and all attributes', () {
        expect(
          RegExp(
            r'Character\(level:\s\d+,\sskills:\s\d+,\sattributes:.+\)$',
          ).hasMatch(Character().toString()),
          isTrue,
        );
      });
    });
  });
}
