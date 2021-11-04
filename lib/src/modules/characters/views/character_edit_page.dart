import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:theme/theme.dart';

typedef OnSave = void Function(Character character);

class CreateCharacterView extends ConsumerWidget {
  const CreateCharacterView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/characters/create';

  static Route<Character?> route() {
    return MaterialPageRoute<Character?>(
      builder: (_) => const CreateCharacterView(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your avatar'),
      ),
      body: EditCharacterLayout(
        onSave: (character) {
          ref.read(authProvider.notifier).addNewCharacter(character);
          Navigator.of(context).pop(character);
        },
      ),
    );
  }
}

class EditCharacterView extends StatelessWidget {
  const EditCharacterView({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  static const routeName = '/character/:id';
  static String path(String id) => pathToFunction(routeName).call({'id': id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EditCharacterLayout(
        character: character,
      ),
    );
  }
}

class EditCharacterLayout extends ConsumerWidget {
  const EditCharacterLayout({
    Key? key,
    this.character,
    this.onSave,
  }) : super(key: key);

  final Character? character;
  final OnSave? onSave;

  static const double _kSpacing = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        characterControllerProvider.overrideWithValue(
          CharacterController(initialState: character ?? Character()),
        )
      ],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(_kSpacing),
          child: Column(
            children: [
              const Header(),
              const Gap(_kSpacing * 2),
              const CharacterAvatar(),
              const Gap(_kSpacing),
              const Attributes(),
              ActionButtons(onSave: onSave),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsPoints = ref.watch(characterControllerProvider).skills;
    return Text('Skill points available: $skillsPoints');
  }
}

class CharacterAvatar extends ConsumerWidget {
  const CharacterAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final character = ref.watch(characterControllerProvider);
    final controller = ref.read(characterControllerProvider.notifier);
    final index = Avatar.all.indexWhere(
      (avatar) => avatar.name == character.name,
    );
    final avatar = Avatar.all[index];

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            PathIcon(avatar.icon, size: 45),
            const Gap(8),
            Text(avatar.name, style: theme.textTheme.caption),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: index > 0
                ? () => controller.setName(Avatar.all[index - 1].name)
                : null,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: index < Avatar.all.length - 1
                ? () => controller.setName(Avatar.all[index + 1].name)
                : null,
          ),
        )
      ],
    );
  }
}

class Attributes extends ConsumerWidget {
  const Attributes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final character = ref.watch(characterControllerProvider);
    final controller = ref.read(characterControllerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final attribute in character.attributes)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            constraints: const BoxConstraints(minHeight: 60),
            child: Row(
              children: [
                Expanded(
                  // todo attribute.label
                  child: Text('${attribute.runtimeType}'),
                ),
                Expanded(
                  child: Center(
                    child: Text('${attribute.points}'),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        splashRadius: 16,
                        onPressed: controller.canBeDowngraded(attribute)
                            ? () => controller.downgrade(attribute)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      IconButton(
                        splashRadius: 16,
                        onPressed: controller.canBeUpgraded(attribute)
                            ? () => controller.upgrade(attribute)
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}

class ActionButtons extends ConsumerWidget {
  const ActionButtons({
    Key? key,
    this.onSave,
  }) : super(key: key);

  final OnSave? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ButtonBar(
      children: [
        TextButton(
          style: TextButton.styleFrom(primary: Colors.white70),
          onPressed: () {
            ref.read(characterControllerProvider.notifier).refresh();
          },
          child: const Text('RESET'),
        ),
        TextButton(
          style: TextButton.styleFrom(primary: Colors.white),
          onPressed: () => onSave?.call(ref.read(characterControllerProvider)),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
