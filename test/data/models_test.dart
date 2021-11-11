import 'dart:async';

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFight extends Mock implements Fight {}

class WrongAttribute extends Attribute {
  WrongAttribute(int points) : super(points);

  @override
  Attribute copyWith({int? points}) => this;

  @override
  String label() => 'WrongAttribute';
}

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

  group('Character', () {
    group('attribute', () {
      final character = Character();

      test('return all attribute', () {
        expect(character.attributes.length, equals(4));
      });

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
          expect(character<Health>().points, equals(10));
        });

        test('initial attack is 0', () {
          expect(character<Attack>().points, equals(0));
        });

        test('initial defense is 0', () {
          expect(character<Defense>().points, equals(0));
        });

        test('initial magik is 0', () {
          expect(character<Magik>().points, equals(0));
        });

        test('has Health attribute', () {
          expect(attributes[Health], isNotNull);
        });

        test('has Attack attribute', () {
          expect(attributes[Attack], isNotNull);
        });

        test('has Defense attribute', () {
          expect(attributes[Defense], isNotNull);
        });

        test('has Magik attribute', () {
          expect(attributes[Magik], isNotNull);
        });
      });
    });

    group('lastFight', () {
      test('when character did not fight return null', () {
        final character = Character();
        expect(character.lastFight, isNull);
      });

      test('when character did fight return latest', () {
        final fights = <Fight>[
          Fight(date: DateTime.now().subtract(const Duration(days: 1))),
          Fight(date: DateTime.now()),
        ];

        final character = Character(fights: fights);

        expect(character.lastFight, equals(fights[1]));
      });
    });

    group('didLooseFightInPastHour', () {
      test('when character did not fight return false', () {
        final character = Character();
        expect(character.didLooseFightInPastHour(), isFalse);
      });

      test('when character did not loose return false', () {
        final fight = MockFight();
        final character = Character(fights: [fight]);
        when(() => fight.date).thenReturn(DateTime.now());
        when(() => fight.didWin(character)).thenReturn(true);
        expect(character.didLooseFightInPastHour(), isFalse);
      });

      test('when character did loose return true', () {
        final fight = MockFight();
        final character = Character(fights: [fight]);
        when(() => fight.date).thenReturn(DateTime.now());
        when(() => fight.didWin(character)).thenReturn(false);
        expect(character.didLooseFightInPastHour(), isTrue);
      });
    });

    group('upgrade', () {
      test('add attribute and remove skills', () {
        final A = Character(skills: 1, health: 10).upgrade<Health>();
        final B = Character(skills: 1, attack: 3).upgrade<Attack>();
        final C = Character(skills: 2, defense: 9).upgrade<Defense>();
        final D = Character(skills: 7, magik: 32).upgrade<Magik>();

        expect(A<Health>().points, equals(11));
        expect(A.skills, equals(0));

        expect(B<Attack>().points, equals(4));
        expect(B.skills, equals(0));

        expect(C<Defense>().points, equals(10));
        expect(C.skills, equals(0));

        expect(D<Magik>().points, equals(33));
        expect(D.skills, equals(0));
      });
    });

    group('downgrade', () {
      test('remove attribute and add skills', () {
        final A = Character(skills: 0, health: 11).downgrade<Health>();
        final B = Character(skills: 0, attack: 4).downgrade<Attack>();
        final C = Character(skills: 0, defense: 10).downgrade<Defense>();
        final D = Character(skills: 0, magik: 33).downgrade<Magik>();

        expect(A<Health>().points, equals(10));
        expect(A.skills, equals(1));

        expect(B<Attack>().points, equals(3));
        expect(B.skills, equals(1));

        expect(C<Defense>().points, equals(9));
        expect(C.skills, equals(2));

        expect(D<Magik>().points, equals(32));
        expect(D.skills, equals(7));
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
        expect(character<Health>().points, equals(12));
        expect(character<Attack>().points, equals(1));
        expect(character<Defense>().points, equals(1));
        expect(character<Magik>().points, equals(1));
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

    group('error', () {
      test('should throw error if attribute type do not exist', () {
        final character = Character();
        Object? error;

        runZonedGuarded(
          () => character.getAttribute<WrongAttribute>(),
          (err, _) => error = err,
        );

        expect(
          error,
          isA<AttributeNotFoundException>().having(
            (dynamic e) => e.toString(),
            'AttributeNotFoundException override toString()',
            equals('Undefine attribute of type WrongAttribute'),
          ),
        );
      });
    });
  });

  group('Attribute', () {
    group('skills point cost', () {
      test('Health(44): costs 1 skill points to increase to 45', () {
        const health = Health(44);
        expect(health.skillsCost, equals(1));
      });

      test('Attack(3): costs 1 skill points to increase to 4', () {
        const attack = Attack(3);
        expect(attack.skillsCost, equals(1));
      });

      test('Defense(9): costs 2 skill points to increase to 10', () {
        const defense = Defense(9);
        expect(defense.skillsCost, equals(2));
      });

      test('Magik(32): costs 7 skill points to increase to 33', () {
        const magik = Magik(32);
        expect(magik.skillsCost, equals(7));
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

    group('equality', () {
      test('unit are equals', () {
        const attributeA = Health(1);
        const attributeB = Health(1);
        expect(attributeA == attributeB, isTrue);
        expect(attributeA.hashCode == attributeB.hashCode, isTrue);
      });

      test('unit are not equals', () {
        const attributeA = Health(21);
        const attributeB = Health(11);
        expect(attributeA == attributeB, isFalse);
      });

      test('list are equals', () {
        const listA = [Health(1), Health(2)];
        const listB = [Health(1), Health(2)];
        expect(listEquals(listA, listB), isTrue);
      });

      test('list are not equals', () {
        const listA = [Health(1), Health(2)];
        const listB = [Health(3), Health(4)];
        expect(listEquals(listA, listB), isFalse);
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

  group('Fight', () {
    final now = DateTime.now();
    final characterA = Character(id: 'A');
    final characterB = Character(id: 'B');
    final round = Round(id: 1, attacker: characterA, defender: characterB);

    test('equality', () {
      final A = Fight(date: now, rounds: []);
      final B = Fight(date: now, rounds: [round]);
      final C = Fight(date: now, rounds: []);

      expect(A != B, isTrue);
      expect(A.hashCode != B.hashCode, isTrue);
      expect(A != C, isFalse);
    });

    test('copyWith', () {
      final A = Fight(date: now, rounds: []);
      final yesterday = now.subtract(const Duration(days: 1));

      expect(A.copyWith().date, equals(A.date));
      expect(A.copyWith().rounds, equals(A.rounds));
      expect(A.copyWith(date: yesterday).date, equals(yesterday));
      expect(A.copyWith(rounds: [round]).rounds, equals([round]));
    });

    test('toString', () {
      final A = Fight(date: now, rounds: []);

      expect(A.toString(), 'Fight(date: $now)');
    });
  });

  group('FightResult', () {
    final characterA = Character(id: 'A');
    final characterB = Character(id: 'B');
    final fight = Fight(date: DateTime.now(), rounds: []);

    test('equality', () {
      final A = FightResult(
        character: characterA,
        opponent: characterB,
        didWin: true,
        fight: fight,
      );

      final B = FightResult(
        character: characterB,
        opponent: characterA,
        didWin: false,
        fight: fight,
      );

      final C = FightResult(
        character: characterA,
        opponent: characterB,
        didWin: true,
        fight: fight,
      );

      expect(A != B, isTrue);
      expect(A.hashCode != B.hashCode, isTrue);
      expect(A != C, isFalse);
    });
  });

  group('Round model', () {
    final attacker = Character(id: 'attacker');
    final defender = Character(id: 'defender');

    group('succeed', () {
      test('when damages is higher than 0, succeed return true', () {
        final round = Round(
          id: 1,
          damages: 10,
          attacker: attacker,
          defender: defender,
        );

        expect(round.succeed, isTrue);
      });

      test('when damages equals 0, succeed return false', () {
        final round = Round(
          id: 1,
          damages: 0,
          attacker: attacker,
          defender: defender,
        );

        expect(round.succeed, isFalse);
      });
    });

    group('copyWith', () {
      test('override id', () {
        final round = Round(id: 1, attacker: attacker, defender: defender);
        expect(round.id, equals(1));
        expect(round.copyWith(id: 2).id, equals(2));
      });

      test('override diceResult', () {
        final round = Round(id: 1, attacker: attacker, defender: defender);
        expect(round.diceResult, equals(0));
        expect(round.copyWith(diceResult: 2).diceResult, equals(2));
      });

      test('override damages', () {
        final round = Round(id: 1, attacker: attacker, defender: defender);
        expect(round.damages, equals(0));
        expect(round.copyWith(damages: 2).damages, equals(2));
      });

      test('override attacker', () {
        final round = Round(id: 1, attacker: attacker, defender: defender);
        expect(round.attacker, equals(attacker));
        expect(round.copyWith(attacker: defender).attacker, equals(defender));
      });

      test('override defender', () {
        final round = Round(id: 1, attacker: attacker, defender: defender);
        expect(round.defender, equals(defender));
        expect(round.copyWith(defender: attacker).defender, equals(attacker));
      });
    });

    test('toString', () {
      final round = Round(id: 1, attacker: attacker, defender: defender);
      expect(
        RegExp(r'^Round\(\S+').hasMatch(round.toString()),
        isTrue,
      );
    });

    test('equality', () {
      final roundA = Round(id: 1, attacker: attacker, defender: defender);
      final roundB = Round(id: 2, attacker: attacker, defender: defender);
      final roundC = Round(id: 1, attacker: attacker, defender: defender);
      expect(roundA == roundB, isFalse);
      expect(roundA.hashCode == roundB.hashCode, isFalse);
      expect(roundA == roundC, isTrue);
    });
  });

  group('IterableExtension on Model', () {
    final characterA = Character(id: 'A');
    final characterB = Character(id: 'B', skills: 100);

    test('when character is in list, exist return true', () {
      expect([characterA, characterB].exist(characterA), isTrue);
    });

    test('when character is not in list, exist return false', () {
      expect([characterB].exist(characterA), isFalse);
    });

    test('replace() update desired value', () {
      final list = <Character>[characterA, characterB];
      expect(list.last.skills, equals(100));

      final update = list.replace(Character(id: 'B', skills: 10));
      expect(update.last.skills, equals(10));
    });

    test('delete() remove desired value', () {
      final list = <Character>[characterA, characterB];

      final update = list.delete(characterB);
      expect(update, [characterA]);
    });
  });
}
