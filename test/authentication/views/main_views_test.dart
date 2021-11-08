import 'package:fight_club/src/app.dart';
import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/character.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/authentication/view/onboarding.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
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
      verifyNever(() => storage.write(any(), any()));
      await tester.tap(find.byKey(const Key('save_character')));
      verify(() => storage.write(any(), any())).called(1);
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
}
