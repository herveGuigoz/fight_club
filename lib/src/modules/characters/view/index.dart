import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

typedef OnSave = void Function(Character character);

class CreateCharacterView extends StatelessWidget {
  const CreateCharacterView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/characters/create';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EditCharacterLayout(),
    );
  }
}

class EditCharacterView extends StatelessWidget {
  const EditCharacterView({
    Key? key,
    required this.caracterId,
  }) : super(key: key);

  final String caracterId;

  static const routeName = '/character/:id';
  static String path(String id) => pathToFunction(routeName).call({'id': id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EditCharacterLayout(caracterId: caracterId),
    );
  }
}

class EditCharacterLayout extends ConsumerWidget {
  const EditCharacterLayout({
    Key? key,
    this.caracterId,
    this.onSave,
  }) : super(key: key);

  final String? caracterId;
  final OnSave? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider(caracterId)).character;

    return Padding(
      padding: const EdgeInsets.all(16.0), // todo theme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skill points available: ${character.skills}'), // todo theme
          const Gap(16),
          for (final attribute in character.attributes)
            AttributeListTile(
              character: character,
              attribute: attribute,
              onTap: CharacterController.canBeUpgraded(character, attribute)
                  ? () => ref.upgrade(attribute, caracterId: caracterId)
                  : null,
            ),
          const Spacer(),
          ButtonBar(
            children: [
              TextButton(
                onPressed: () {
                  ref.refresh(characterProvider(caracterId).notifier);
                },
                child: const Text('RESET'),
              ),
              TextButton(
                onPressed: () => onSave?.call(character),
                child: const Text('SAVE'),
              ),
            ],
          )
        ],
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
            child: Text('${attribute.runtimeType}'), // todo attribute.name
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
