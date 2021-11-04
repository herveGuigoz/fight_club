import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _scopedCharacter = Provider<Character>(
  (ref) => throw UnimplementedError(),
);

class CharacterReadView extends ConsumerWidget {
  const CharacterReadView({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  static Route<void> route({required Character character}) {
    return MaterialPageRoute<void>(
      builder: (_) => CharacterReadView(character: character),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        _scopedCharacter.overrideWithValue(character),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(character.name),
            actions: [
              IconButton(
                iconSize: 16,
                splashRadius: 24,
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                iconSize: 16,
                splashRadius: 24,
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Attributes'),
                Tab(text: 'Fights'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AttributesLayout(),
              FightsLayout(),
            ],
          ),
        ),
      ),
    );
  }
}

class AttributesLayout extends ConsumerWidget {
  const AttributesLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(_scopedCharacter);

    return ListTileTheme(
      dense: true,
      child: ListView(
        children: [
          ListTile(
            title: const Text('Level'),
            trailing: Text(character.level.toString()),
          ),
          ListTile(
            title: const Text('Skills'),
            trailing: Text(character.skills.toString()),
          ),
          for (final attribute in character.attributes)
            ListTile(
              title: Text(attribute.runtimeType.toString()),
              trailing: Text(attribute.points.toString()),
            ),
        ],
      ),
    );
  }
}

class FightsLayout extends ConsumerWidget {
  const FightsLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(_scopedCharacter);
    final fights = character.fights;

    if (fights.isEmpty) {
      return const Center(
        child: Text('This character did not fight'),
      );
    }

    return ListView(
      children: [
        for (final fight in fights)
          ListTile(
            title: Text(fight.didWin(character) ? 'win' : 'loss'),
            onTap: () {
              Navigator.of(context).push(
                FightResumeView.route(character, fight),
              );
            },
          ),
      ],
    );
  }
}

class FightResumeView extends StatelessWidget {
  const FightResumeView({
    Key? key,
    required this.character,
    required this.fight,
  }) : super(key: key);

  final Character character;
  final Fight fight;

  static Route<void> route(Character character, Fight fight) {
    return MaterialPageRoute<void>(
      builder: (_) => FightResumeView(character: character, fight: fight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FightResumeLayout(character: character, fight: fight),
    );
  }
}
