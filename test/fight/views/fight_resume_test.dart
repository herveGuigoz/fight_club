import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:fight_club/src/modules/lobby/views/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  final characterA = Character(id: 'A');
  final characterB = Character(id: 'B');
  final fight = Fight(
    date: DateTime.now(),
    rounds: [
      Round(id: 1, attacker: characterA, defender: characterB, damages: 5),
      Round(id: 2, attacker: characterB, defender: characterA, damages: 10),
    ],
  );
  final result = FightResult(
    character: characterA,
    opponent: characterB,
    fight: fight,
    didWin: false,
  );

  group('FightResumeView', () {
    testWidgets('should push to FightResumeView view', (tester) async {
      await tester.pumpApp(
        Material(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => Navigator.of(context).push(
                  FightResumeView.route(characterA, fight),
                ),
                child: const Text('ClickMe'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(FightResumeView), findsOneWidget);
    });

    testWidgets('Should display app bar', (tester) async {
      await tester.pumpApp(
        FightResumeView(character: characterA, fight: fight),
      );
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Should display FightResumeLayout', (tester) async {
      await tester.pumpApp(
        FightResumeView(character: characterA, fight: fight),
      );
      expect(find.byType(FightResumeLayout), findsOneWidget);
    });
  });

  group('FightResultView', () {
    testWidgets('should push to FightResultView view', (tester) async {
      await tester.pumpApp(
        Material(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => Navigator.of(context).push(
                  FightResultView.route(),
                ),
                child: const Text('ClickMe'),
              );
            },
          ),
        ),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncData(result)),
        ],
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(FightResultView), findsOneWidget);
    });

    testWidgets('should display FightResumeLayout', (tester) async {
      await tester.pumpApp(
        const FightResultView(),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncData(result)),
        ],
      );

      expect(find.byType(FightResumeLayout), findsOneWidget);
    });

    testWidgets('should display CircularProgressIndicator', (tester) async {
      await tester.pumpApp(
        const FightResultView(),
        overrides: [
          fightResultProvider.overrideWithValue(const AsyncLoading()),
        ],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message', (tester) async {
      await tester.pumpApp(
        const FightResultView(),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncError(FightException())),
        ],
      );

      expect(
        find.text('Fight could not be processed, both characters cant attack'),
        findsOneWidget,
      );
    });
  });

  group('FightResumeLayout', () {
    testWidgets('when winner, should display fight result.', (tester) async {
      await tester.pumpApp(
        Material(
          child: FightResumeLayout(character: characterB, fight: fight),
        ),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncError(FightException())),
        ],
      );

      expect(find.text('You win'), findsOneWidget);
    });

    testWidgets('when loosed, should display fight result.', (tester) async {
      await tester.pumpApp(
        Material(
          child: FightResumeLayout(character: characterA, fight: fight),
        ),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncError(FightException())),
        ],
      );

      expect(find.text('You loss'), findsOneWidget);
    });

    testWidgets('should display all rounds results', (tester) async {
      await tester.pumpApp(
        Material(
          child: FightResumeLayout(character: characterB, fight: fight),
        ),
        overrides: [
          fightResultProvider.overrideWithValue(AsyncError(FightException())),
        ],
      );

      expect(find.byType(RoundListTile), findsNWidgets(2));
    });
  });
}
