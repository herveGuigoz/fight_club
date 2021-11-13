import 'package:fight_club/src/app.dart';
import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/character.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('FightClub', () {
    testWidgets('should display Onboarding if unauthenticated', (tester) async {
      setUpStorage();
      await tester.pumpApp(const FightClub());

      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });

  group('Onboarding', () {
    testWidgets('should display CharacterLayout', (tester) async {
      setUpStorage();
      await tester.pumpApp(const OnboardingView());

      expect(find.byType(CharacterLayout), findsOneWidget);
    });

    testWidgets('should save character', (tester) async {
      final storage = setUpStorage();
      await tester.pumpApp(const OnboardingView());
      verifyNever(() => storage.write(any(), any<dynamic>()));
      await tester.tap(find.byKey(const Key('save_character')));
      verify(() => storage.write(any(), any<dynamic>())).called(1);
    });
  });

  group('Home', () {
    const codec = SessionCodec();

    testWidgets('should display CharactersListView', (tester) async {
      setUpStorage(
        onRead: codec.toMap(Session(characters: [Character(id: 'A')])),
      );
      await tester.pumpApp(const Home());
      expect(find.byType(CharactersListView), findsOneWidget);
    });

    testWidgets('should display FloatingActionButton', (tester) async {
      setUpStorage(
        onRead: codec.toMap(Session(characters: [Character()])),
      );
      await tester.pumpApp(const Home());
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should not display FloatingActionButton', (tester) async {
      setUpStorage(
        onRead: codec.toMap(
          Session(characters: List.generate(10, (_) => Character())),
        ),
      );
      await tester.pumpApp(const Home());
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('should redirect to CreateCharacterView', (tester) async {
      setUpStorage(
        onRead: codec.toMap(Session(characters: [Character()])),
      );
      await tester.pumpApp(const Home());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(CreateCharacterView), findsOneWidget);
    });

    testWidgets('should render BottomNavigationBar', (tester) async {
      setUpStorage(
        onRead: codec.toMap(Session(characters: [Character()])),
      );
      await tester.pumpApp(const Home());
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should render LobbyView', (tester) async {
      setUpStorage(
        onRead: codec.toMap(Session(characters: [Character()])),
      );
      await tester.pumpApp(const Home());
      await tester.tap(find.text('Lobby'));
      await tester.pumpAndSettle();

      expect(find.byType(LobbyView), findsOneWidget);
    });
  });

  group('Lobby', () {
    const codec = SessionCodec();
    testWidgets('should be alowed to select another character', (tester) async {
      final characterA = Character(name: 'Stormtrooper');
      final characterB = Character(name: 'Yoda');
      final controller = StateProvider<Character?>((ref) {
        final characters = ref.watch(availableCharactersProvider);
        return characters.isNotEmpty ? characters.first : null;
      });

      setUpStorage(
        onRead: codec.toMap(Session(characters: [characterA, characterB])),
      );

      late final WidgetRef widgetRef;

      await tester.pumpApp(
        Consumer(
          builder: (context, ref, child) {
            widgetRef = ref;
            return const Home();
          },
        ),
        overrides: [selectedCharacterProvider.overrideWithProvider(controller)],
      );

      expect(widgetRef.read(selectedCharacterProvider), equals(characterA));

      await tester.tap(find.text('Lobby'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('${characterA.name} - level ${characterA.level}'),
      );

      // finish the menu animation
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(
        find.text('${characterB.name} - level ${characterB.level}').last,
      );

      await tester.pump(const Duration(seconds: 1));

      expect(widgetRef.read(selectedCharacterProvider), equals(characterB));
    });

    testWidgets('Fight button should not be visible', (tester) async {
      setUpStorage(onRead: codec.toMap(const Session()));
      await tester.pumpApp(const Home());
      await tester.tap(find.text('Lobby'));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('Fight button should be enable', (tester) async {
      final character = Character(name: 'Stormtrooper');
      setUpStorage(
        onRead: codec.toMap(Session(characters: [character])),
      );
      await tester.pumpApp(const Home());
      await tester.tap(find.text('Lobby'));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Fight button should push to FightResultView', (tester) async {
      final characterA = Character(name: 'Stormtrooper');
      final characterB = Character(name: 'Yoda');
      final fightResult = FightResult(
        character: characterA,
        opponent: characterB,
        didWin: true,
        fight: Fight(date: DateTime.now()),
      );

      setUpStorage(
        onRead: codec.toMap(Session(characters: [characterA])),
      );
      await tester.pumpApp(
        const Home(),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncData(fightResult)),
        ],
      );
      await tester.tap(find.text('Lobby'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(FightResultView), findsOneWidget);
    });
  });
}
