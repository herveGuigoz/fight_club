import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/characters/views/character_read_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme/theme.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/storage.dart';

const codec = SessionCodec();

void main() {
  group('Character list page', () {
    setUp(() {
      setUpStorage(
        onRead: codec.toMap(
          Session(characters: List.generate(5, (index) => Character())),
        ),
      );
    });
    testWidgets('should display app bar', (tester) async {
      await tester.pumpApp(const Material(child: CharactersListView()));
      expect(find.text('Characters'), findsOneWidget);
    });

    testWidgets('should display avatars', (tester) async {
      await tester.pumpApp(const Material(child: CharactersListView()));
      expect(find.byType(PathIcon), findsNWidgets(5));
    });

    testWidgets('should display characters names', (tester) async {
      await tester.pumpApp(const Material(child: CharactersListView()));
      expect(find.text('Anonymous'), findsNWidgets(5));
    });

    testWidgets('should display characters levels', (tester) async {
      await tester.pumpApp(const Material(child: CharactersListView()));
      expect(find.text('Level: 1'), findsNWidgets(5));
    });

    testWidgets('should redirect to CharacterReadView on tap', (tester) async {
      await tester.pumpApp(const Material(child: CharactersListView()));
      await tester.tap(find.text('Level: 1').first);
      await tester.pumpAndSettle();
      expect(find.byType(CharacterReadView), findsOneWidget);
    });
  });
}
