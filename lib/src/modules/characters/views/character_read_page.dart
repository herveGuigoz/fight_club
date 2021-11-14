import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

/// Retrieve the character's details
class CharacterReadView extends ConsumerWidget {
  /// Render attibutes and fight tab views inside [Scaffold] widget with
  /// delete icon button.
  const CharacterReadView(this.character, {Key? key}) : super(key: key);

  /// The selected character.
  final Character character;

  /// MaterialPageRoute that will render CharacterReadView.
  static Route<void> route(Character character) {
    return MaterialPageRoute<void>(
      builder: (_) => CharacterReadView(character),
    );
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
                if (await DeleteCharacterDialog.show(context) ?? false) {
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

/// Read only attribute's details list view.
class AttributesLayout extends ConsumerStatefulWidget {
  /// Render outlined rows for character's level, skills and attributes with
  /// edit text button that will push [EditCharacterView] on top of the stack.
  const AttributesLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  /// The selected character.
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
        padding: const EdgeInsets.all(16),
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
            for (final attribute in character.attributes.values)
              OutlinedListTile(
                label: attribute.label(),
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

/// Retrieve the list of fights for a character with the result (won/loose)
class FightsLayout extends StatelessWidget {
  /// Show ListView of all fights for the given character.
  const FightsLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  /// The selected character.
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

/// Request confirmation before deleting character from the current session.
class DeleteCharacterDialog extends StatelessWidget {
  /// Show AlertDialog with `Cancel` and `Ok` call-to-action buttons.
  const DeleteCharacterDialog({Key? key}) : super(key: key);

  /// Return user's validation to delete a character.
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
