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
            userCharactersProvider.overrideWithValue([caracter])
          ],
        );
        controller = container.read(characterControllerProvider.notifier);
      });

      test('health skill', () {
        controller.upgrade(caracter.health);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.health.points, equals(11));
        expect(updatedCharacter.skills, equals(11));
      });

      test('attack skill', () {
        controller.upgrade(caracter.attack);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.attack.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('defense skill', () {
        controller.upgrade(caracter.defense);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.defense.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('magik skill', () {
        controller.upgrade(caracter.magik);
        final updatedCharacter = container.read(characterControllerProvider);
        expect(updatedCharacter.magik.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });
    });
    group('providers', () {
      test('instantiate default character if no id is provided', () {
        final container = createContainer(
          overrides: [userCharactersProvider.overrideWithValue([])],
        );
        final state = container.read(characterControllerProvider);
        expect(state, isA<Character>());
      });

      test('find character by ids', () {
        final character = Character(magik: 10);
        final container = createContainer(
          overrides: [
            userCharactersProvider.overrideWithValue([character])
          ],
        );
        expect(
          container.read(characterControllerProvider).hashCode,
          equals(character.hashCode),
        );
      });
    });
  });
}
