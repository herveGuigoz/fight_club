import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Edit character view', () {
    setUp(setUpStorage);

    group('create', () {
      testWidgets('should display app bar', (tester) async {
        await tester.pumpApp(const CreateCharacterView());
        expect(find.text('Create your avatar'), findsOneWidget);
      });

      testWidgets('avatar selection should be enable', (tester) async {
        await tester.pumpApp(const CreateCharacterView());
        expect(find.byType(CharacterAvatar), findsOneWidget);
        expect(find.text(Avatar.all[0].name), findsOneWidget);
        await tester.tap(find.byKey(const Key('next_avatar')));
        await tester.pumpAndSettle();
        expect(find.text(Avatar.all[0].name), findsNothing);
        expect(find.text(Avatar.all[1].name), findsOneWidget);
      });

      testWidgets('should display all attribute list tiles', (tester) async {
        final character = Character(health: 1, attack: 2, defense: 3, magik: 4);
        await tester.pumpApp(EditCharacterView(character: character));

        expect(find.text(character<Health>().label()), findsOneWidget);
        expect(find.text('${character<Health>().points}'), findsOneWidget);

        expect(find.text(character<Attack>().label()), findsOneWidget);
        expect(find.text('${character<Attack>().points}'), findsOneWidget);

        expect(find.text(character<Defense>().label()), findsOneWidget);
        expect(find.text('${character<Defense>().points}'), findsOneWidget);

        expect(find.text(character<Magik>().label()), findsOneWidget);
        expect(find.text('${character<Magik>().points}'), findsOneWidget);
      });

      testWidgets('should display action button', (tester) async {
        await tester.pumpApp(EditCharacterView(character: Character()));
        expect(find.byType(ActionButtons), findsOneWidget);
      });

      testWidgets('should add new character', (tester) async {
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
        await tester.pumpApp(EditCharacterView(character: Character()));
        expect(find.byType(CharacterAvatar), findsNothing);
      });

      testWidgets('should display all attribute list tiles', (tester) async {
        final character = Character(health: 1, attack: 2, defense: 3, magik: 4);
        await tester.pumpApp(EditCharacterView(character: character));

        expect(find.text(character<Health>().label()), findsOneWidget);
        expect(find.text('${character<Health>().points}'), findsOneWidget);

        expect(find.text(character<Attack>().label()), findsOneWidget);
        expect(find.text('${character<Attack>().points}'), findsOneWidget);

        expect(find.text(character<Defense>().label()), findsOneWidget);
        expect(find.text('${character<Defense>().points}'), findsOneWidget);

        expect(find.text(character<Magik>().label()), findsOneWidget);
        expect(find.text('${character<Magik>().points}'), findsOneWidget);
      });

      testWidgets('should display action button', (tester) async {
        await tester.pumpApp(EditCharacterView(character: Character()));
        expect(find.byType(ActionButtons), findsOneWidget);
      });
    });

    group('CharacterAvatar', () {
      testWidgets('avatar selection should update name', (tester) async {
        final controller = MockCharacterController(Character());
        await tester.pumpApp(
          const Material(child: CharacterAvatar()),
          overrides: [
            characterControllerProvider.overrideWithValue(controller),
          ],
        );

        await tester.tap(find.byKey(const Key('next_avatar')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('previous_avatar')));
        await tester.pumpAndSettle();

        expect(controller.setNameCallCount, equals(2));
      });
    });

    group('AttributeListTile', () {
      testWidgets('should edit Health attributes', (tester) async {
        final character = Character(health: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Health')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsNothing);
        expect(find.text('21'), findsOneWidget);

        await tester.tap(find.byKey(const Key('downgrade_Health')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNothing);
        expect(find.text('20'), findsOneWidget);
      });

      testWidgets('should not edit Health attributes', (tester) async {
        final character = Character(skills: 0, health: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Health')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsOneWidget);
        expect(find.text('21'), findsNothing);
      });

      testWidgets('should edit Attack attributes', (tester) async {
        final character = Character(attack: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Attack')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsNothing);
        expect(find.text('21'), findsOneWidget);

        await tester.tap(find.byKey(const Key('downgrade_Attack')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNothing);
        expect(find.text('20'), findsOneWidget);
      });

      testWidgets('should not edit Attack attributes', (tester) async {
        final character = Character(skills: 0, attack: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Attack')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsOneWidget);
        expect(find.text('21'), findsNothing);
      });

      testWidgets('should edit Defense attributes', (tester) async {
        final character = Character(defense: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Defense')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsNothing);
        expect(find.text('21'), findsOneWidget);

        await tester.tap(find.byKey(const Key('downgrade_Defense')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNothing);
        expect(find.text('20'), findsOneWidget);
      });

      testWidgets('should not edit Defense attributes', (tester) async {
        final character = Character(skills: 0, defense: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Defense')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsOneWidget);
        expect(find.text('21'), findsNothing);
      });

      testWidgets('should edit Magik attributes', (tester) async {
        final character = Character(magik: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Magik')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsNothing);
        expect(find.text('21'), findsOneWidget);

        await tester.tap(find.byKey(const Key('downgrade_Magik')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNothing);
        expect(find.text('20'), findsOneWidget);
      });

      testWidgets('should not edit Magik attributes', (tester) async {
        final character = Character(skills: 0, magik: 20);

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Magik')));
        await tester.pumpAndSettle();
        expect(find.text('20'), findsOneWidget);
        expect(find.text('21'), findsNothing);
      });
    });

    group('ActionButtons', () {
      testWidgets('should reset to initial attributes', (tester) async {
        final character = Character(
          skills: 100,
          health: 20,
          attack: 20,
          defense: 20,
          magik: 20,
        );

        await tester.pumpApp(EditCharacterView(character: character));

        await tester.tap(find.byKey(const Key('upgrade_Health')));
        await tester.tap(find.byKey(const Key('upgrade_Attack')));
        await tester.tap(find.byKey(const Key('upgrade_Defense')));
        await tester.tap(find.byKey(const Key('upgrade_Magik')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNWidgets(4));

        await tester.tap(find.byKey(const Key('reset_character')));
        await tester.pumpAndSettle();
        expect(find.text('21'), findsNothing);
        expect(find.text('20'), findsNWidgets(4));
      });
    });
  });
}
