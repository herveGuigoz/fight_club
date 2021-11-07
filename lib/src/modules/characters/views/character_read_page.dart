import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterReadView extends ConsumerWidget {
  const CharacterReadView({
    Key? key,
    required this.characterId,
  }) : super(key: key);

  final String characterId;

  static const routeName = '/character/:id';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(findCharacterById(characterId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(character.name),
          actions: [
            IconButton(
              iconSize: 16,
              splashRadius: 24,
              onPressed: () async {
                final decision = await DeleteCharacterDialog.show(context);
                if (decision ?? false) {
                  Navigator.of(context).pop();
                  ref.read(authProvider.notifier).removeCharacter(character);
                }
              },
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
        body: TabBarView(
          children: [
            AttributesLayout(character: character),
            FightsLayout(character: character),
          ],
        ),
      ),
    );
  }
}

class AttributesLayout extends StatelessWidget {
  const AttributesLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AttributeListTile(
              label: 'Level',
              value: character.level,
            ),
            AttributeListTile(
              label: 'Skills',
              value: character.skills,
            ),
            for (final attribute in character.attributes)
              AttributeListTile(
                label: attribute.runtimeType.toString(),
                value: attribute.points,
              ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    EditCharacterView.route(character),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AttributeListTile extends StatelessWidget {
  const AttributeListTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      constraints: const BoxConstraints(minHeight: 60),
      child: Row(
        children: [
          Text(label),
          Expanded(child: Center(child: Text('$value'))),
        ],
      ),
    );
  }
}

class FightsLayout extends StatelessWidget {
  const FightsLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
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

class DeleteCharacterDialog extends StatelessWidget {
  const DeleteCharacterDialog({Key? key}) : super(key: key);

  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => const DeleteCharacterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Caution!'),
      content: const Text('This character will be deleted'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
