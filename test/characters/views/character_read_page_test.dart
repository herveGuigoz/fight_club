import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/characters/views/character_read_page.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

const codec = SessionCodec();

void main() {
  group('Character read page', () {
    final character = Character(name: 'Vegeta');

    group('character read view', () {
      testWidgets('should display avatar name', (tester) async {
        await tester.pumpApp(CharacterReadView(character));
        expect(find.text('Vegeta'), findsOneWidget);
      });

      testWidgets('should display delete button', (tester) async {
        await tester.pumpApp(CharacterReadView(character));
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('display DeleteCharacterDialog on delete', (tester) async {
        await tester.pumpApp(CharacterReadView(character));
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();
        expect(find.byType(DeleteCharacterDialog), findsOneWidget);
        expect(find.text('Caution!'), findsOneWidget);
        expect(find.text('This character will be deleted'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Ok'), findsOneWidget);
      });

      testWidgets('dont delete characterDialog, just pop', (tester) async {
        final authController = MockAuthController();
        await tester.pumpApp(
          CharacterReadView(character),
          overrides: [authProvider.overrideWithValue(authController)],
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(DeleteCharacterDialog), findsNothing);
        verifyNever(() => authController.removeCharacter(character));
      });

      testWidgets('delete characterDialog and pop', (tester) async {
        final authController = MockAuthController();
        await tester.pumpApp(
          CharacterReadView(character),
          overrides: [authProvider.overrideWithValue(authController)],
        );

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();

        expect(find.byType(DeleteCharacterDialog), findsNothing);
        expect(find.byType(CharacterReadView), findsNothing);
        verify(() => authController.removeCharacter(character)).called(1);
      });

      testWidgets('should display tab bar', (tester) async {
        await tester.pumpApp(CharacterReadView(character));
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.text('Attributes'), findsOneWidget);
        expect(find.text('Fights'), findsOneWidget);
      });

      testWidgets('should display tabs view', (tester) async {
        await tester.pumpApp(CharacterReadView(character));

        await tester.tap(find.text('Fights'));
        await tester.pumpAndSettle();
        expect(find.byType(FightsLayout), findsOneWidget);

        await tester.tap(find.text('Attributes'));
        await tester.pumpAndSettle();
        expect(find.byType(AttributesLayout), findsOneWidget);
      });
    });

    group('attributes layout', () {
      final character = Character(
        id: 'uuid',
        name: 'Vegeta',
        level: 2,
        skills: 10,
        health: 20,
        attack: 5,
        defense: 6,
        magik: 7,
      );

      testWidgets('should display character level', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Level'), findsOneWidget);
        expect(find.text('${character.level}'), findsOneWidget);
      });

      testWidgets('should display character skills', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Skills'), findsOneWidget);
        expect(find.text('${character.skills}'), findsOneWidget);
      });

      testWidgets('should display character health', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Health'), findsOneWidget);
        expect(find.text('${character<Health>().points}'), findsOneWidget);
      });

      testWidgets('should display character attack', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Attack'), findsOneWidget);
        expect(find.text('${character<Attack>().points}'), findsOneWidget);
      });

      testWidgets('should display character defense', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Defense'), findsOneWidget);
        expect(find.text('${character<Defense>().points}'), findsOneWidget);
      });

      testWidgets('should display character magik', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.text('Magik'), findsOneWidget);
        expect(find.text('${character<Magik>().points}'), findsOneWidget);
      });

      testWidgets('should display edit button', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        expect(find.byType(TextButton), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
      });

      testWidgets('should redirect to EditCharacterView', (tester) async {
        await tester.pumpApp(AttributesLayout(character: character));
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();
        expect(find.byType(EditCharacterView), findsOneWidget);
      });

      testWidgets('should update state when edited', (tester) async {
        final authController = MockAuthController();
        await tester.pumpApp(
          AttributesLayout(character: character),
          overrides: [authProvider.overrideWithValue(authController)],
        );

        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('increment_Health')));
        await tester.tap(find.byKey(const Key('save_character')));
        await tester.pumpAndSettle();

        expect(find.byType(EditCharacterView), findsNothing);
        expect(find.byType(AttributesLayout), findsOneWidget);
        expect(find.text('${character<Health>().points + 1}'), findsOneWidget);
        verify(
          () => authController.updateCharacter(character.copyWith(
            skills: character.skills - 1,
            health: character<Health>().points + 1,
          )),
        ).called(1);
      });
    });

    group('fights layout', () {
      testWidgets('display `This character did not fight`', (tester) async {
        await tester.pumpApp(FightsLayout(character: character));
        expect(find.text('This character did not fight'), findsOneWidget);
      });
      testWidgets('should display list of fights', (tester) async {
        final other = Character();

        await tester.pumpApp(
          Material(
            child: FightsLayout(
              character: character.copyWith(
                fights: [
                  Fight(
                    date: DateTime.now(),
                    rounds: [
                      Round(id: 1, attacker: character, defender: other),
                    ],
                  ),
                  Fight(
                    date: DateTime.now(),
                    rounds: [
                      Round(id: 2, attacker: other, defender: character),
                    ],
                  )
                ],
              ),
            ),
          ),
        );

        expect(find.text('win'), findsOneWidget);
        expect(find.text('loss'), findsOneWidget);
      });
    });

    testWidgets('should redirect to FightResumeView', (tester) async {
      await tester.pumpApp(
        Material(
          child: FightsLayout(
            character: character.copyWith(
              fights: [Fight(date: DateTime.now())],
            ),
          ),
        ),
      );
      await tester.tap(find.text('loss'));
      await tester.pumpAndSettle();

      expect(find.byType(FightResumeView), findsOneWidget);
    });
  });
}
