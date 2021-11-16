import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockFight extends Mock implements Fight {}

void main() {
  group('Auth controller', () {
    const codec = SessionCodec();
    test('Read state from cache', () {
      final session = Session(
        characters: [Character(level: 10)],
      );
      final storage = setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();
      final expected = container.read(authProvider);

      verify<void>(() => storage.read(any())).called(1);
      expect(session, equals(expected));
    });

    test('Add new character to state', () {
      setUpStorage();

      final container = createContainer();
      expect(container.read(authProvider).characters, isEmpty);

      container.read(authProvider.notifier).addNewCharacter(Character());
      expect(container.read(authProvider).characters, isNotEmpty);
    });

    test('Write to cache new state', () {
      final storage = setUpStorage();
      final container = createContainer();
      container.read(authProvider.notifier).addNewCharacter(Character());
      verify(() => storage.write(any(), any<dynamic>())).called(1);
    });

    test('update character that match id', () {
      final characterA = Character(id: 'A', level: 10);
      final characterB = Character(id: 'B', level: 20);
      final characterC = Character(id: 'C', level: 30);
      final characterD = Character(id: 'B', level: 40);

      final session = Session(characters: [characterA, characterB]);
      setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();
      container.read(authProvider.notifier).updateCharacter(characterC);
      final stateA = container.read(authProvider);
      expect(stateA.characters.length, equals(2));
      expect(stateA.characters[0], equals(characterA));
      expect(stateA.characters[1], equals(characterB));

      container.read(authProvider.notifier).updateCharacter(characterD);
      final stateB = container.read(authProvider);
      expect(stateB.characters.length, equals(2));
      expect(stateB.characters[0], equals(characterA));
      expect(stateB.characters[1], equals(characterD));
    });

    test('remove character that match id', () {
      final characterA = Character(id: 'A', level: 10);
      final characterB = Character(id: 'B', level: 20);
      final characterC = Character(id: 'C', level: 30);

      final session = Session(characters: [characterA, characterB]);
      setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();

      container.read(authProvider.notifier).removeCharacter(characterC);
      final stateA = container.read(authProvider);
      expect(stateA.characters.length, equals(2));
      expect(stateA.characters[0], equals(characterA));
      expect(stateA.characters[1], equals(characterB));

      container.read(authProvider.notifier).removeCharacter(characterA);
      final stateB = container.read(authProvider);
      expect(stateB.characters.length, equals(1));
      expect(stateB.characters[0], equals(characterB));
    });

    test('when character won a fight, level and skills are upgrated', () {
      final fight = MockFight();
      final characterA = Character(id: 'A', skills: 0);
      final characterB = Character(id: 'A', skills: 0);
      when(() => fight.didWin(characterB)).thenReturn(true);

      final session = Session(characters: [characterA, characterB]);
      setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();

      container.read(authProvider.notifier).didFight(characterB, fight);
      final state = container.read(authProvider).characters;

      expect(state.first.level, equals(2));
      expect(state.first.skills, equals(1));
    });

    test('when character loss a fight, attribute did not change', () {
      final fight = MockFight();
      final characterA = Character(id: 'A', skills: 0);
      final characterB = Character(id: 'A', skills: 0);
      when(() => fight.didWin(characterB)).thenReturn(false);

      final session = Session(characters: [characterA, characterB]);
      setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();

      container.read(authProvider.notifier).didFight(characterB, fight);
      final state = container.read(authProvider).characters;

      expect(state.first.level, equals(1));
      expect(state.first.skills, equals(0));
    });

    test('Throw CharactersLengthLimitException when exceed 10 characters', () {
      final characters = List.generate(10, (_) => Character());
      final session = Session(characters: characters);

      setUpStorage(onRead: codec.toMap(session));

      final container = createContainer();
      final controller = container.read(authProvider.notifier);
      expect(
        () => controller.addNewCharacter(Character()),
        throwsA(isA<CharactersLengthLimitException>()),
      );
    });

    test('CharactersLengthLimitException overrides toString', () {
      expect(
        CharactersLengthLimitException().toString(),
        'Maximum $kCharactersLengthLimit characters per player is allowed',
      );
    });
  });
}
