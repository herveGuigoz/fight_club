import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Attribute', () {
    group('skills point cost', () {
      test('Health(44): costs 1 skill points to increase to 45', () {
        const health = Health(44);
        expect(health.skillsPointCosts, equals(1));
      });

      test('Attack(3): costs 1 skill points to increase to 4', () {
        const attack = Attack(3);
        expect(attack.skillsPointCosts, equals(1));
      });

      test('Defense(9): costs 2 skill points to increase to 10', () {
        const defense = Defense(9);
        expect(defense.skillsPointCosts, equals(2));
      });

      test('Magik(32): costs 7 skill points to increase to 33', () {
        const magik = Magik(32);
        expect(magik.skillsPointCosts, equals(7));
      });
    });

    group('operators', () {
      const health = Health(44);

      test('add one increase points by one', () {
        expect(health + 1, equals(45));
      });

      test('remove one decrease points by one', () {
        expect(health - 1, equals(43));
      });
    });

    group('to string', () {
      test('return attribute type and points value', () {
        const health = Health(44);
        const attack = Attack(3);
        const defense = Defense(9);
        const magik = Magik(21);
        expect(health.toString(), equals('Health(44)'));
        expect(attack.toString(), equals('Attack(3)'));
        expect(defense.toString(), equals('Defense(9)'));
        expect(magik.toString(), equals('Magik(21)'));
      });
    });
  });
}
