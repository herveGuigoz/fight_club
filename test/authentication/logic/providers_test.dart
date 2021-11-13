import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockFight extends Mock implements Fight {}

void main() {
  group('Auth providers', () {
    group('userCharactersProvider', () {
      test('when characters change, return updated characters', () {
        setUpStorage();
        final container = createContainer();
        expect(container.read(userCharactersProvider), isEmpty);

        container.read(authProvider.notifier).addNewCharacter(Character());
        expect(container.read(userCharactersProvider), isNotEmpty);
      });
    });

    group('hasCharactersProvider', () {
      test('when characters is added, provider is updated', () {
        setUpStorage();
        final container = createContainer();
        expect(container.read(hasCharactersProvider), isFalse);

        container.read(authProvider.notifier).addNewCharacter(Character());
        expect(container.read(hasCharactersProvider), isTrue);
      });
    });

    group('isCharacterCreationAllowedProvider', () {
      test('when characters count is higher or equals to 10 return false', () {
        setUpStorage();
        final container = createContainer();

        for (var i = 1; i <= 10; i++) {
          container.read(authProvider.notifier).addNewCharacter(Character());
          expect(container.read(userCharactersProvider).length, equals(i));
          if (i == 10) {
            expect(container.read(isCharacterCreationAllowedProvider), isFalse);
          } else {
            expect(container.read(isCharacterCreationAllowedProvider), isTrue);
          }
        }
      });
    });

    group('availableCharactersProvider', () {
      test('return only characters that did not loosed in last 24 hours', () {
        final fight = MockFight();
        final characterA = Character(fights: [fight]);
        final characterB = Character();

        when(() => fight.didWin(characterA)).thenReturn(false);
        when(() => fight.date).thenReturn(DateTime.now());

        setUpStorage();
        final container = createContainer();
        container.read(authProvider.notifier).state = Session(
          characters: [characterA, characterB],
        );

        expect(container.read(availableCharactersProvider), [characterB]);
      });
    });
  });
}
