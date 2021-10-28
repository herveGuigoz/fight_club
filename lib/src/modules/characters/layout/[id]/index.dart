import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CharacterLayout extends ConsumerWidget {
  const CharacterLayout({
    Key? key,
    required this.caracterId,
  }) : super(key: key);

  final String caracterId;

  static Route route(String caracterId) {
    return MaterialPageRoute<void>(
      builder: (_) => CharacterLayout(caracterId: caracterId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider(caracterId));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // todo theme
        child: Column(
          children: [
            Text('Skills: ${character.skills}'), // todo theme
            const Gap(16),
            for (final attribute in character.attributes)
              AttributeListTile(
                character: character,
                attribute: attribute,
                onTap: CharacterLogic.canBeIncremented(character, attribute)
                    ? () => ref
                        .read(characterProvider(caracterId).notifier)
                        .increment(attribute)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

class AttributeListTile extends StatelessWidget {
  const AttributeListTile({
    Key? key,
    required this.character,
    required this.attribute,
    this.onTap,
  }) : super(key: key);

  final Character character;
  final Attribute attribute;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // todo theme
      padding: const EdgeInsets.all(8), // todo theme
      decoration: BoxDecoration(border: Border.all()), // todo theme
      child: Row(
        children: [
          Expanded(
            child: Text('${attribute.runtimeType}'),
          ),
          Expanded(
            child: Center(
              child: Text(attribute.points.toString()), // todo theme
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.add), // todo theme
                ),
                Text(
                  '- ${attribute.skillsPointCosts} skills',
                  style: theme.textTheme.caption, // todo theme
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
