import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('Character controller', () {
    group('upgrade', () {
      final caracter = Character();
      late ProviderContainer container;
      late CharacterController controller;

      setUp(() {
        container = createContainer(
          overrides: [
            charactersProvider.overrideWithValue([caracter])
          ],
        );
        controller = container.read(characterProvider(caracter.id).notifier);
      });

      test('health skill', () {
        controller.upgrade(caracter.health);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.character.health.points, equals(11));
        expect(updatedCharacter.character.skills, equals(11));
      });

      test('attack skill', () {
        controller.upgrade(caracter.attack);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.character.attack.points, equals(1));
        expect(updatedCharacter.character.skills, equals(11));
      });

      test('defense skill', () {
        controller.upgrade(caracter.defense);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.character.defense.points, equals(1));
        expect(updatedCharacter.character.skills, equals(11));
      });

      test('magik skill', () {
        controller.upgrade(caracter.magik);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.character.magik.points, equals(1));
        expect(updatedCharacter.character.skills, equals(11));
      });
    });
    group('providers', () {
      test('instantiate default character if no id is provided', () {
        final container = createContainer(
          overrides: [charactersProvider.overrideWithValue([])],
        );
        final state = container.read(characterProvider(null));
        expect(state.character, isA<Character>());
      });

      test('find character by ids', () {
        final character = Character(magik: 10);
        final container = createContainer(
          overrides: [
            charactersProvider.overrideWithValue([character])
          ],
        );
        expect(
          container.read(characterProvider(character.id)).character.hashCode,
          equals(character.hashCode),
        );
      });

      test(
        'should throw CharacterLogicException when calling increment on'
        'attribute where skillsPointCosts is higher than character\'s skills',
        () {
          final character = Character(skills: 1, magik: 32);
          final container = createContainer(
            overrides: [
              charactersProvider.overrideWithValue([character])
            ],
          );
          expect(
            () => container
                .read(characterProvider(character.id).notifier)
                .upgrade(character.magik),
            throwsA(isA<CharacterUpgradeException>()),
          );
        },
      );
    });
  });

  group('CharacterLogicException', () {
    test('override toString', () {
      final character = Character();

      expect(
        CharacterUpgradeException(character, character.attack).toString(),
        'Could not upgrade ${character.attack} on $character.'
        'Ensure that character has enought skills to upgrade this value:'
        'Increasing 1 point costs ${character.attack.skillsPointCosts} skills amount',
      );
    });
  });
}
