import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/core/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

void main() {
  group('Auth controller', () {
    const codec = CharacterCodec();

    test('Read state from cache', () {
      final characters = [Character(level: 10)];
      final storage = setUpStorage(onRead: {
        kCharactersStorageKey: codec.encodeList(characters),
      });

      final container = createContainer();
      final session = container.read(authProvider);

      verify(() => storage.read(any())).called(1);
      expect(session.characters, equals(characters));
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
      verify(() => storage.write(any(), any())).called(2);
    });

    test(
      'should throw CharactersLengthLimitException when exceed 10 characters',
      () {
        final characters = List.generate(10, (_) => Character());

        setUpStorage(onRead: {
          kCharactersStorageKey: codec.encodeList(characters),
        });

        final container = createContainer();
        final controller = container.read(authProvider.notifier);
        expect(
          () => controller.addNewCharacter(Character()),
          throwsA(isA<CharactersLengthLimitException>()),
        );
      },
    );

    test('CharactersLengthLimitException overrides toString', () {
      expect(
        CharactersLengthLimitException().toString(),
        'Maximum $kCharactersLengthLimit characters per player is allowed',
      );
    });
  });
}
