// ignore_for_file: cascade_invocations

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
        final character = Character(skills: 0);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        expect(controller.canBeUpgraded<Health>(), isFalse);
      });

      test('when skill point amount is acalible return true', () {
        final character = Character(skills: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        expect(controller.canBeUpgraded<Health>(), isTrue);
      });
    });

    group('canBeDowngraded', () {
      test('when attribute did not changed return false', () {
        final character = Character(skills: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);

        expect(controller.canBeDowngraded<Health>(), isFalse);
      });

      test('when attribute changed return true', () {
        final character = Character(skills: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        controller.upgrade<Health>();
        expect(
          controller.canBeDowngraded<Health>(),
          isTrue,
        );
      });
    });

    group('upgrade', () {
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
      });

      test('health skill', () {
        controller.upgrade<Health>();
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter<Health>().points, equals(11));
        expect(updatedCharacter.skills, equals(11));
      });

      test('attack skill', () {
        controller.upgrade<Attack>();
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter<Attack>().points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('defense skill', () {
        controller.upgrade<Defense>();
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter<Defense>().points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('magik skill', () {
        controller.upgrade<Magik>();
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter<Magik>().points, equals(1));
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
        controller.upgrade<Health>();
        controller.upgrade<Attack>();
        controller.upgrade<Defense>();
        controller.upgrade<Magik>();
      });

      test('health skill', () {
        controller.downgrade<Health>();
        final update = container.read(characterControllerProvider);
        expect(update<Health>().points, equals(character<Health>().points));
      });

      test('attack skill', () {
        controller.downgrade<Attack>();
        final update = container.read(characterControllerProvider);
        expect(update<Attack>().points, equals(character<Attack>().points));
      });

      test('defense skill', () {
        controller.downgrade<Defense>();
        final update = container.read(characterControllerProvider);
        expect(update<Defense>().points, equals(character<Defense>().points));
      });

      test('magik skill', () {
        controller.downgrade<Magik>();
        final update = container.read(characterControllerProvider);
        expect(update<Magik>().points, equals(character<Magik>().points));
      });
    });

    group('refresh', () {
      test('reset to initial state', () {
        final character = Character(skills: 10);
        final container = createContainer(
          overrides: [
            characterControllerProvider.overrideWithValue(
              CharacterController(initialState: character),
            )
          ],
        );
        final controller = container.read(characterControllerProvider.notifier);
        controller.upgrade<Health>();
        controller.upgrade<Attack>();
        controller.upgrade<Defense>();
        controller.upgrade<Magik>();

        final stateA = container.read(characterControllerProvider);
        expect(stateA<Health>().points, equals(11));
        expect(stateA<Attack>().points, equals(1));
        expect(stateA<Defense>().points, equals(1));
        expect(stateA<Magik>().points, equals(1));

        controller.refresh();
        final stateB = container.read(characterControllerProvider);
        expect(stateB<Health>().points, equals(10));
        expect(stateB<Attack>().points, equals(0));
        expect(stateB<Defense>().points, equals(0));
        expect(stateB<Magik>().points, equals(0));
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
