import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('Auth providers', () {
    group('charactersProvider', () {
      test('return new characters', () {
        setUpStorage();
        final container = createContainer();
        expect(container.read(userCharactersProvider), isEmpty);
        container.read(authProvider.notifier).addNewCharacter(Character());
        expect(container.read(userCharactersProvider), isNotEmpty);
      });
    });
  });
}
