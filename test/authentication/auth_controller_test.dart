import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

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

      verify(() => storage.read(any())).called(1);
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
      verify(() => storage.write(any(), any())).called(1);
    });

    test(
      'should throw CharactersLengthLimitException when exceed 10 characters',
      () {
        final characters = List.generate(10, (_) => Character());
        final session = Session(characters: characters);

        setUpStorage(onRead: codec.toMap(session));

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
