import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFight extends Mock implements Fight {}

void main() {
  group('Caracters controller', () {
    group('fake characters', () {
      test('Generate random characters', () async {
        final controller = CharactersController();
        final characters = await controller.getRandomCharacters(count: 2);
        expect(characters.length, equals(2));
        expect(characters[0] != characters[1], isTrue);
      });
    });

    group('find opponent', () {
      test('The character has to be free', () async {
        final fight = MockFight();
        final characterA = Character(fights: [fight]);
        final characterB = Character(level: 100, fights: []);
        when(() => fight.didWin(characterA)).thenReturn(false);
        when(() => fight.date).thenReturn(DateTime.now());

        final controller = CharactersController([characterA, characterB]);
        final theOne = await controller.findOpponentFor(Character(level: 1));
        expect(theOne, equals(characterB));
      });

      test('if no one is free, should generate new characters', () async {
        final now = DateTime.now();
        final fightA = Fight(
          id: 'fightA',
          date: now,
          rounds: [
            Round(
              id: 1,
              attacker: Character(id: 'characterA'),
              defender: Character(id: 'characterB'),
            ),
          ],
        );
        final fightB = Fight(
          id: 'fightB',
          date: now,
          rounds: [
            Round(
              id: 1,
              attacker: Character(id: 'characterB'),
              defender: Character(id: 'characterA'),
            ),
          ],
        );

        Character characterA = Character(id: 'characterA', fights: [fightB]);
        Character characterB = Character(id: 'characterB', fights: [fightA]);

        expect(characterA.didLooseFightInPastHour(), isTrue);
        expect(characterB.didLooseFightInPastHour(), isTrue);

        final controller = CharactersController([characterA, characterB]);
        final theOne = await controller.findOpponentFor(Character());
        expect(theOne.id == characterA.id, isFalse);
        expect(theOne.id == characterB.id, isFalse);
      });

      test('Take the closest opponent based on rank value', () async {
        final characterA = Character(level: 1);
        final characterB = Character(level: 25);
        final characterC = Character(level: 12);

        final controller = CharactersController(
          [characterA, characterB, characterC],
        );

        final theOne = await controller.findOpponentFor(Character(level: 21));
        expect(theOne, equals(characterB));
      });

      test('Take the opponent with the smallest number of fights', () async {
        final user = Character(level: 10);
        final fight = MockFight();
        final characterA = Character(
          id: 'A',
          level: 10,
          fights: [fight],
        );

        final characterB = Character(
          level: 10,
          fights: [],
        );

        final characterC = Character(
          id: 'B',
          level: 10,
          fights: [fight, fight],
        );

        when(() => fight.didWin(characterA)).thenReturn(true);
        when(() => fight.didWin(characterC)).thenReturn(true);
        when(() => fight.date).thenReturn(DateTime.now());

        final controller = CharactersController(
          [characterA, characterB, characterC],
        );

        final theOne = await controller.findOpponentFor(user);

        expect(characterA.didLooseFightInPastHour(), isFalse);
        expect(characterB.didLooseFightInPastHour(), isFalse);
        expect(characterC.didLooseFightInPastHour(), isFalse);

        expect(characterA.level, equals(user.level));
        expect(characterB.level, equals(user.level));
        expect(characterB.level, equals(user.level));

        expect(theOne, equals(characterB));
      });

      test('Take a random opponent within the list', () async {
        final characters = List.generate(100, (i) => Character(id: '$i'));

        final controller = CharactersController(characters);

        final selectionA = await controller.findOpponentFor(Character());
        final selectionB = await controller.findOpponentFor(Character());

        expect(selectionA == selectionB, isFalse);
      });
    });

    group('FightObserver implementation', () {
      test('when character did fight state is updated', () {
        final fight = MockFight();
        final characterA = Character(id: 'A');
        final characterB = Character(id: 'B');
        final controller = CharactersController([characterA, characterB]);
        when(() => fight.didWin(characterA)).thenReturn(true);

        controller.didFight(characterA, fight);
        expect(controller.state[0].fights.isEmpty, isFalse);
        expect(controller.state[1].fights.isEmpty, isTrue);
      });
    });
  });
}
