import 'package:fight_club/src/app.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:theme/theme.dart';

import '../../helpers/helpers.dart';

class MockCharacterController extends CharacterController {
  MockCharacterController(Character character) : super(initialState: character);

  int setNameCallCount = 0;

  @override
  void setName(String name) {
    setNameCallCount++;
    super.setName(name);
  }
}

void main() {
  group('Edit character view', () {
    group('create', () {
      testWidgets('should display app bar', (tester) async {
        await tester.pumpApp(
          const CreateCharacterView(),
          overrides: [userCharactersProvider.overrideWithValue([])],
        );
        expect(find.text('Create your avatar'), findsOneWidget);
      });

      testWidgets('avatar selection should be enable', (tester) async {
        await tester.pumpApp(
          const CreateCharacterView(),
          overrides: [userCharactersProvider.overrideWithValue([])],
        );
        expect(find.byType(CharacterAvatar), findsOneWidget);
        expect(find.text(Avatar.all[0].name), findsOneWidget);
        await tester.tap(find.byKey(const Key('next_avatar')));
        await tester.pumpAndSettle();
        expect(find.text(Avatar.all[0].name), findsNothing);
        expect(find.text(Avatar.all[1].name), findsOneWidget);
      });

      testWidgets('avatar selection should update name', (tester) async {
        final controller = MockCharacterController(Character());
        await tester.pumpApp(
          const Material(child: CharacterAvatar()),
          overrides: [
            userCharactersProvider.overrideWithValue([]),
            characterControllerProvider.overrideWithValue(controller),
          ],
        );
        expect(controller.setNameCallCount, equals(0));

        await tester.tap(find.byKey(const Key('next_avatar')));
        await tester.pumpAndSettle();
        expect(controller.setNameCallCount, equals(1));

        await tester.tap(find.byKey(const Key('previous_avatar')));
        await tester.pumpAndSettle();
        expect(controller.setNameCallCount, equals(2));
      });

      testWidgets('should add new character', (tester) async {
        setUpStorage();
        await tester.pumpApp(const Home());
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(ListTile), findsNothing);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(CreateCharacterView), findsOneWidget);
        expect(find.byKey(const Key('save_character')), findsOneWidget);

        await tester.tap(find.byKey(const Key('save_character')));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsOneWidget);
      });
    });

    group('update', () {
      testWidgets('should display app bar with character name', (tester) async {
        await tester.pumpApp(
          EditCharacterView(character: Character(name: 'Sangoku')),
        );
        expect(find.text('Sangoku'), findsOneWidget);
      });

      testWidgets('avatar selection should not be enable', (tester) async {
        await tester.pumpApp(
          EditCharacterView(character: Character()),
        );
        expect(find.byType(CharacterAvatar), findsNothing);
      });
    });

    group('attributes', () {});
  });
}
