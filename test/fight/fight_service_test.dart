import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDice extends Mock implements Dice {}

void main() {
  group('FightService', () {
    group('dice:', () {
      test('result is always in range 1 - max', () {
        for (var max = 1; max < 10; max++) {
          final result = const Dice().roll(max);
          expect(result >= 1, isTrue);
          expect(result <= max, isTrue);
        }
      });
    });
    group('processRound:', () {
      final dice = MockDice();

      test('if attacker point is 0, return untouched characters', () {
        final characterA = Character(attack: 0);
        final characterB = Character(attack: 10);

        final round = FightService.processRound(1, characterA, characterB);
        expect(round.attacker, equals(characterA));
        expect(round.defender, equals(characterB));
      });

      test(
        'Damages value is the difference between Attack and Defenses Skills'
        'Points amount',
        () {
          const attack = 20;
          const defense = 10;

          final characterA = Character(attack: attack);
          final characterB = Character(defense: defense);

          FightService.dice = dice;
          when(() => dice.roll(any())).thenReturn(attack);

          final round = FightService.processRound(1, characterA, characterB);
          expect(round.damages, equals(attack - defense));
        },
      );

      test('roll dice with max faces as the Attacks Skill Point amount', () {
        FightService.dice = const Dice();
        final A = Character(attack: 5);
        final B = Character(attack: 5);
        final rounds = List.generate(
          20,
          (_) => FightService.processRound(1, A, B),
        );

        expect(
          rounds.any((round) => round.diceResult > A.attack.points),
          isFalse,
        );
      });

      group('Attack succeed', () {
        test(
          'the difference is substracted from the opponents Health Point',
          () {
            const attack = 20;
            const defense = 10;
            const health = 50;

            final characterA = Character(attack: attack);
            final characterB = Character(defense: defense, health: health);

            FightService.dice = dice;
            when(() => dice.roll(any())).thenReturn(attack);

            final round = FightService.processRound(1, characterA, characterB);
            expect(
              round.defender.health.points,
              equals(health - (attack - defense)),
            );
          },
        );

        test(
          'If the difference equals Magiks Skill Point amount, this value is '
          'added to the difference',
          () {
            const attack = 10;
            const defense = 3;
            const magick = 7;

            final characterA = Character(attack: attack, magik: magick);
            final characterB = Character(defense: defense, health: 24);

            FightService.dice = dice;
            when(() => dice.roll(any())).thenReturn(attack);

            final round = FightService.processRound(1, characterA, characterB);
            expect(round.damages, equals(14));
            expect(round.defender.health.points, equals(10));
          },
        );
      });

      group('Attack failed', () {
        test('the difference is 0', () {
          const attack = 10;
          const defense = 20;

          final characterA = Character(attack: attack);
          final characterB = Character(defense: defense);

          FightService.dice = dice;
          when(() => dice.roll(any())).thenReturn(attack);

          final round = FightService.processRound(1, characterA, characterB);
          expect(round.damages, equals(0));
        });
      });
    });

    group('processFight', () {
      final A = Character(attack: 10, defense: 10, health: 20);
      final B = Character(attack: 10, defense: 5, health: 10);

      test('launchFight return Fight', () async {
        final result = await FightService().launchFight(A, B);
        expect(result, isA<Fight>());
      });
      test(
        'until a characters Health Point reaches 0, the fight continues',
        () {
          final rounds = FightService.processFight(IsolateEntry(A, B));
          final roundsWithHealthPointsSmallerThanOne = <Round>[];
          for (final round in rounds) {
            if (round.defender.health.points < 1) {
              roundsWithHealthPointsSmallerThanOne.add(round);
            }
          }
          expect(roundsWithHealthPointsSmallerThanOne.length, equals(1));
        },
      );

      test('throw exception if any characters can win', () async {
        expect(
          () async => FightService().launchFight(
            Character(attack: 5, defense: 10),
            Character(attack: 5, defense: 10),
          ),
          throwsA(isA<FightException>()),
        );
      });

      test('FightException overrides toString', () async {
        expect(
          FightException().toString(),
          'Fight could not be processed, both characters cant attack',
        );
      });
    });

    group('fight result', () {
      test('FightResult.won is true when user win', () async {
        final characterA = Character(attack: 10, defense: 10);
        final characterB = Character(attack: 5, defense: 5);

        final result = await FightService().launchFight(
          characterA,
          characterB,
        );

        expect(result.didWin(characterA), isTrue);
      });

      test('FightResult.won is false when user loose', () async {
        final characterA = Character(attack: 1, defense: 1);
        final characterB = Character(attack: 10, defense: 10);

        final result = await FightService().launchFight(
          characterA,
          characterB,
        );

        expect(result.didWin(characterA), isFalse);
      });
    });
  });
}
