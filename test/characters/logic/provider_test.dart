import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';
import '../../helpers/riverpod.dart';

void main() {
  group('Characters provider', () {
    final characterA = Character(id: 'A');
    final characterB = Character(id: 'B');
    final characters = [characterA, characterB];

    test('caractersProvider return instance of CaractersController', () {
      final container = createContainer();
      expect(container.read(charactersProvider), isA<CharactersController>());
    });

    test('selectedCharacter return null if any characters is available', () {
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue([]),
      ]);

      final selectedCharacter = container.read(selectedCharacterProvider);

      expect(selectedCharacter, isNull);
    });

    test('selectedCharacterProvider return first character by default', () {
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue(characters),
      ]);

      final selectedCharacter = container.read(selectedCharacterProvider);

      expect(selectedCharacter, equals(characterA));
    });

    test('can update selectedCharacterProvider', () {
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue(characters),
      ]);

      var selectedCharacter = container.read(selectedCharacterProvider);
      expect(selectedCharacter, equals(characterA));

      final controller = container.read(selectedCharacterProvider.state);
      controller.state = characterB;
      selectedCharacter = container.read(selectedCharacterProvider);
      expect(selectedCharacter, equals(characterB));
    });

    test('fightService return instance of FightService', () {
      setUpStorage();
      final container = createContainer();
      expect(container.read(fightService), isA<FightService>());
    });

    test('When character win, return correct fight result', () async {
      setUpStorage();
      final characterA = Character(id: 'A', attack: 10, defense: 10);
      final characterB = Character(id: 'B', attack: 1, defense: 1);
      final charactersController = CharactersController([characterB]);
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue([characterA]),
        charactersProvider.overrideWithValue(charactersController),
      ]);

      late final FightResult result;

      container.listen(fightResultProvider, (_, state) {
        if (state is AsyncData<FightResult>) result = state.value;
      });

      container.read(fightResultProvider);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(result.didWin, isTrue);
      expect(result.character, equals(characterA));
      expect(result.opponent, equals(characterB));
    });

    test('When character loss, return correct fight result', () async {
      setUpStorage();
      final characterA = Character(id: 'A', attack: 1, defense: 1);
      final characterB = Character(id: 'B', attack: 10, defense: 10);
      final charactersController = CharactersController([characterB]);
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue([characterA]),
        charactersProvider.overrideWithValue(charactersController),
      ]);

      late final FightResult result;

      container.listen(fightResultProvider, (_, state) {
        if (state is AsyncData<FightResult>) result = state.value;
      });

      container.read(fightResultProvider);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(result.didWin, isFalse);
      expect(result.character, equals(characterA));
      expect(result.opponent, equals(characterB));
    });

    test('fightResultProvider throw SelectedCharacterNotfound', () async {
      final container = createContainer(overrides: [
        availableCharactersProvider.overrideWithValue([]),
      ]);

      expect(container.read(selectedCharacterProvider), isNull);

      Object? error;

      try {
        await container.read(fightResultProvider.future);
      } catch (err) {
        error = err;
      }

      expect(error, isA<SelectedCharacterNotfound>());
    });

    test('SelectedCharacterNotfound override toString', () {
      expect(
        SelectedCharacterNotfound().toString(),
        'There is no character selected for the fight',
      );
    });
  });
}
