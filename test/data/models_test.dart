import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFight extends Mock implements Fight {}

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
  group('Character model', () {
    group('attribute', () {
      final character = Character();

      test('return all attribute to list', () {
        expect(character.attributes.length, equals(4));
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

    group('operators', () {
      test('+ add attribute and remove skills', () {
        final A = Character(skills: 1, health: 10) + const Health(10);
        final B = Character(skills: 1, attack: 3) + const Attack(3);
        final C = Character(skills: 2, defense: 9) + const Defense(9);
        final D = Character(skills: 7, magik: 32) + const Magik(32);

        expect(A.health.points, equals(11));
        expect(A.skills, equals(0));

        expect(B.attack.points, equals(4));
        expect(B.skills, equals(0));

        expect(C.defense.points, equals(10));
        expect(C.skills, equals(0));

        expect(D.magik.points, equals(33));
        expect(D.skills, equals(0));
      });

      test('- remove attribute and add skills', () {
        final A = Character(skills: 0, health: 11) - const Health(11);
        final B = Character(skills: 0, attack: 4) - const Attack(4);
        final C = Character(skills: 0, defense: 10) - const Defense(10);
        final D = Character(skills: 0, magik: 33) - const Magik(33);

        expect(A.health.points, equals(10));
        expect(A.skills, equals(1));

        expect(B.attack.points, equals(3));
        expect(B.skills, equals(1));

        expect(C.defense.points, equals(9));
        expect(C.skills, equals(2));

        expect(D.magik.points, equals(32));
        expect(D.skills, equals(7));
      });
    });
  });

  group('Fight model', () {
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

  group('FightResult view model', () {
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
