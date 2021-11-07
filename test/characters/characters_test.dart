import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Characters', () {
    const codec = CharacterCodec();
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

    group('equality', () {
      test('unit are equals', () {
        final characterA = Character(id: 'A');
        final characterB = Character(id: 'A');
        expect(characterA == characterB, isTrue);
        expect(characterA.hashCode == characterA.hashCode, isTrue);
      });

      test('unit are not equals', () {
        final characterA = Character(skills: 21);
        final characterB = Character();
        expect(characterA == characterB, isFalse);
      });

      test('list are equals', () {
        final listA = [
          Character(id: 'A', attack: 1),
          Character(id: 'A', attack: 2)
        ];
        final listB = [
          Character(id: 'A', attack: 1),
          Character(id: 'A', attack: 2)
        ];
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
        final characterA = Character(id: 'A');
        final characterB = Character(id: 'A').copyWith();
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
      test('reference name, skills, level and all attributes', () {
        expect(
          RegExp(
            r'Character\(name:\s\w+,\slevel:\s\d+,\sskills:\s\d+,\sattributes:.+\)$',
          ).hasMatch(Character().toString()),
          isTrue,
        );
      });
    });
  });
}
