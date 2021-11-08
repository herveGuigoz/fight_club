import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Character controller', () {
    group('canBeUpgraded', () {
      test('when skill point amount is not enought return false', () {
        final character = Character(skills: 0, health: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        expect(controller.canBeUpgraded(character.health), isFalse);
      });

      test('when skill point amount is acalible return true', () {
        final character = Character(skills: 10, health: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        expect(controller.canBeUpgraded(character.health), isTrue);
      });
    });

    group('canBeDowngraded', () {
      test('when attribute did not changed return false', () {
        final character = Character(skills: 10, health: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);

        expect(controller.canBeDowngraded(character.health), isFalse);
      });

      test('when attribute changed return true', () {
        final character = Character(skills: 10, health: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        controller.upgrade(character.health);
        final update = container.read(characterControllerProvider);
        expect(controller.canBeDowngraded(update.health), isTrue);
      });
    });

    group('upgrade', () {
      final character = Character();
      late ProviderContainer container;
      late CharacterController controller;

      setUp(() {
        container = createContainer(overrides: [
          characterControllerProvider.overrideWithValue(
            CharacterController(initialState: character),
          )
        ]);
        controller = container.read(characterControllerProvider.notifier);
      });

      test('health skill', () {
        controller.upgrade(character.health);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.health.points, equals(11));
        expect(updatedCharacter.skills, equals(11));
      });

      test('attack skill', () {
        controller.upgrade(character.attack);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.attack.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('defense skill', () {
        controller.upgrade(character.defense);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.defense.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('magik skill', () {
        controller.upgrade(character.magik);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.magik.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });
    });

    group('downgrade', () {
      final character = Character();
      late ProviderContainer container;
      late CharacterController controller;

      setUp(() {
        container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        controller = container.read(characterControllerProvider.notifier);
        controller.upgrade(character.health);
        controller.upgrade(character.attack);
        controller.upgrade(character.defense);
        controller.upgrade(character.magik);
      });

      test('health skill', () {
        controller.downgrade(character.health);
        final update = container.read(characterControllerProvider);
        expect(update.health.points, equals(character.health.points));
      });

      test('attack skill', () {
        controller.downgrade(character.attack);
        final update = container.read(characterControllerProvider);
        expect(update.attack.points, equals(character.attack.points));
      });

      test('defense skill', () {
        controller.downgrade(character.defense);
        final update = container.read(characterControllerProvider);
        expect(update.defense.points, equals(character.defense.points));
      });

      test('magik skill', () {
        controller.downgrade(character.magik);
        final update = container.read(characterControllerProvider);
        expect(update.magik.points, equals(character.magik.points));
      });
    });

    group('refresh', () {
      test('reset to initial state', () {
        final character = Character(skills: 10, health: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        controller.upgrade(character.health);
        controller.upgrade(character.attack);
        controller.upgrade(character.defense);
        controller.upgrade(character.magik);

        final stateA = container.read(characterControllerProvider);
        expect(stateA.health.points, equals(11));
        expect(stateA.attack.points, equals(1));
        expect(stateA.defense.points, equals(1));
        expect(stateA.magik.points, equals(1));

        controller.refresh();
        final stateB = container.read(characterControllerProvider);
        expect(stateB.health.points, equals(10));
        expect(stateB.attack.points, equals(0));
        expect(stateB.defense.points, equals(0));
        expect(stateB.magik.points, equals(0));
      });
    });

    group('setName', () {
      test('When setName is call character name is updated', () {
        final character = Character(name: 'A');
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        expect(container.read(characterControllerProvider).name, equals('A'));
        controller.setName('B');
        expect(container.read(characterControllerProvider).name, equals('B'));
      });
    });

    group('characterControllerProvider', () {
      test('instantiate default character if no id is provided', () {
        final container = createContainer();
        final state = container.read(characterControllerProvider);
        expect(state, isA<Character>());
      });
    });

    group('avatarsProvider', () {
      test('when user add new avatar, his remove from provider', () {
        setUpStorage();
        final avatars = Avatar.all;
        final container = createContainer();
        for (final avatar in avatars) {
          container
              .read(authProvider.notifier)
              .addNewCharacter(Character(name: avatar.name));
          final state = container.read(avatarsProvider);
          expect(state.contains(avatar), isFalse);
        }
      });
    });
  });
}
