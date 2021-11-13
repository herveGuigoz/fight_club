import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

/// Fight character selection layout.
class LobbyView extends ConsumerWidget {
  /// Render dropdown button with all avalaible characters and text button to
  /// launch a fight.
  const LobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final characters = ref.watch(availableCharactersProvider);
    final selectedCharacter = ref.watch(selectedCharacterProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (characters.isNotEmpty) ...[
            const Text('Choose your character:'),
            const Gap(16),
            DropdownButton<Character>(
              isExpanded: true,
              value: selectedCharacter,
              onChanged: (character) {
                ref.read(selectedCharacterProvider.state).state = character;
              },
              items: [
                for (final character in characters)
                  DropdownMenuItem(
                    value: character,
                    child: Text('${character.name} - level ${character.level}'),
                  )
              ],
            ),
          ] else
            const Text('No characters are available.'),
          const Gap(16),
          Text(
            'Only characters that have not loosed in the past hour can fight.',
            style: theme.textTheme.caption,
          ),
          const Gap(16),
          if (characters.isNotEmpty)
            ButtonBar(
              children: [
                TextButton(
                  onPressed: selectedCharacter != null
                      ? () =>
                          Navigator.of(context).push(FightResultView.route())
                      : null,
                  child: const Text('Fight'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
