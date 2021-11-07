import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

class CharacterReadView extends ConsumerWidget {
  const CharacterReadView(this.character, {Key? key}) : super(key: key);

  final Character character;

  static Route<T> route<T>(Character character) {
    return MaterialPageRoute<T>(builder: (_) => CharacterReadView(character));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class AttributesLayout extends ConsumerStatefulWidget {
  const AttributesLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  ConsumerState<AttributesLayout> createState() => _AttributesLayoutState();
}

class _AttributesLayoutState extends ConsumerState<AttributesLayout> {
  late Character character = widget.character;

  Future<void> editAttributes() async {
    final updatedCharacter = await Navigator.of(context).push(
      EditCharacterView.route(character),
    );

    if (updatedCharacter != null) {
      ref.read(authProvider.notifier).updateCharacter(updatedCharacter);
      setState(() {
        character = updatedCharacter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            OutlinedListTile(
              label: 'Level',
              value: character.level,
            ),
            OutlinedListTile(
              label: 'Skills',
              value: character.skills,
            ),
            for (final attribute in character.attributes)
              OutlinedListTile(
                label: attribute.runtimeType.toString(),
                value: attribute.points,
              ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: editAttributes,
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
