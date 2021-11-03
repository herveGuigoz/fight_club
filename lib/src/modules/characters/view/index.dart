import 'package:fight_club/src/core/data/models/models.dart';
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

class AttributeListTile extends ConsumerStatefulWidget {
  const AttributeListTile({
    Key? key,
    required this.character,
    required this.attribute,
  }) : super(key: key);

  final Character character;
  final Attribute attribute;

  @override
  ConsumerState<AttributeListTile> createState() => _AttributeListTileState();
}

class _AttributeListTileState extends ConsumerState<AttributeListTile> {
  late final initialAttribute = widget.attribute;

  Character get character => widget.character;
  Attribute get attribute => widget.attribute;

  bool get canBeDowngraded {
    return initialAttribute != attribute;
  }

  bool get canBeUpgraded {
    return CharacterController.canBeUpgraded(character, attribute);
  }

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
            child: Text(
              '${widget.attribute.runtimeType}', // todo attribute.label
            ), // todo attribute.name
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.attribute.points.toString(),
              ), // todo theme
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: canBeDowngraded
                      ? () => ref.downgrade(widget.attribute)
                      : null,
                  icon: const Icon(Icons.remove), // todo theme
                ),
                IconButton(
                  onPressed: canBeUpgraded
                      ? () => ref.upgrade(widget.attribute)
                      : null,
                  icon: const Icon(Icons.add), // todo theme
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
