import 'package:fight_club/src/core/data/models/models.dart';
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

      test('+ increase points by one', () {
        expect(health + 1, equals(45));
      });

      test('- decrease points by one', () {
        expect(health - 1, equals(43));
      });

      test('> return correct boolean', () {
        const healthA = Health(2);
        const healthB = Health(1);
        expect(healthA > healthB, isTrue);
        expect(healthB > healthA, isFalse);
      });

      test('< return correct boolean', () {
        const healthA = Health(2);
        const healthB = Health(1);
        expect(healthA < healthB, isFalse);
        expect(healthB < healthA, isTrue);
      });

      test('>= and <= return correct boolean', () {
        const healthA = Health(1);
        const healthB = Health(1);
        expect(healthA <= healthB, isTrue);
        expect(healthB <= healthA, isTrue);
        expect(healthA >= healthB, isTrue);
        expect(healthB >= healthA, isTrue);
      });
    });

    group('copyWith', () {
      test('must override copyWith()', () {
        const health = Health(0);
        const attack = Attack(0);
        const defense = Defense(0);
        const magik = Magik(0);
        expect(health.copyWith(), equals(health));
        expect(health.copyWith(points: 1), equals(const Health(1)));
        expect(attack.copyWith(), equals(attack));
        expect(attack.copyWith(points: 1), equals(const Attack(1)));
        expect(defense.copyWith(), equals(defense));
        expect(defense.copyWith(points: 1), equals(const Defense(1)));
        expect(magik.copyWith(), equals(magik));
        expect(magik.copyWith(points: 1), equals(const Magik(1)));
      });
    });

    group('must override label()', () {
      test('return correct labels', () {
        const health = Health(44);
        const attack = Attack(3);
        const defense = Defense(9);
        const magik = Magik(21);
        expect(health.label(), equals('Health'));
        expect(attack.label(), equals('Attack'));
        expect(defense.label(), equals('Defense'));
        expect(magik.label(), equals('Magik'));
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
