import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('Character controller', () {
    group('increment', () {
      final caracter = Character();
      late ProviderContainer container;
      late CharacterLogic controller;

      setUp(() {
        container = createContainer(
          overrides: [
            charactersProvider.overrideWithValue([caracter])
          ],
        );
        controller = container.read(characterProvider(caracter.id).notifier);
      });

      test('health skill', () {
        controller.increment(caracter.health);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.health.points, equals(11));
        expect(updatedCharacter.skills, equals(11));
      });

      test('attack skill', () {
        controller.increment(caracter.attack);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.attack.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('defense skill', () {
        controller.increment(caracter.defense);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.defense.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });

      test('magik skill', () {
        controller.increment(caracter.magik);
        final updatedCharacter = container.read(characterProvider(caracter.id));
        expect(updatedCharacter.magik.points, equals(1));
        expect(updatedCharacter.skills, equals(11));
      });
    });
    group('providers', () {
      test('instantiate default character if no id is provided', () {
        final container = createContainer(
          overrides: [charactersProvider.overrideWithValue([])],
        );
        final character = container.read(characterProvider(null));
        expect(character, isA<Character>());
      });

      test('find character by ids', () {
        final character = Character(magik: 10);
        final container = createContainer(
          overrides: [
            charactersProvider.overrideWithValue([character])
          ],
        );
        expect(
          container.read(characterProvider(character.id)).hashCode,
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
                .increment(character.magik),
            throwsA(isA<CharacterLogicException>()),
          );
        },
      );
    });
  });

  group('CharacterLogicException', () {
    test('override toString', () {
      final character = Character();

      expect(
        CharacterLogicException(character, character.attack).toString(),
        'Could not increment ${character.attack} on $character.'
        'Ensure that character has enought skills to increment this value:'
        'Increasing 1 point costs ${character.attack.skillsPointCosts} skills amount',
      );
    });
  });
}
