import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:theme/theme.dart';

/// Callback triggered on form validation
typedef OnSave = void Function(Character character);

/// Edition mode
enum Mode {
  /// Edit avatar and attributes
  create,

  /// Edit attributes only
  update,
}

/// View for character creation.
class CreateCharacterView extends ConsumerWidget {
  /// Render [CharacterLayout] inside [Scaffold] widget with [Avatar] selection.
  const CreateCharacterView({Key? key}) : super(key: key);

  /// MaterialPageRoute that will render CreateCharacterView
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
      body: SingleChildScrollView(
        child: CharacterLayout(
          mode: Mode.create,
          character: Character(name: ref.read(avatarsProvider).first.name),
          onSave: (character) {
            ref.read(authProvider.notifier).addNewCharacter(character);
            Navigator.of(context).pop(character);
          },
        ),
      ),
    );
  }
}

/// View for character edition.
class EditCharacterView extends ConsumerWidget {
  /// Render [CharacterLayout] inside [Scaffold] widget.
  const EditCharacterView({
    Key? key,
    required this.character,
  }) : super(key: key);

  /// The character to edit.
  final Character character;

  /// MaterialPageRoute that will render EditCharacterView
  static Route<Character?> route(Character character) {
    return MaterialPageRoute<Character?>(
      builder: (_) => EditCharacterView(character: character),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: CharacterLayout(
        mode: Mode.update,
        character: character,
        onSave: (character) {
          Navigator.of(context).pop(character);
        },
      ),
    );
  }
}

/// Form to edit or create avatar.
class CharacterLayout extends ConsumerWidget {
  /// Render character skill points avalaible and attributes form.
  /// If [Mode.create], render [Avatar] selection.
  const CharacterLayout({
    Key? key,
    required this.character,
    required this.mode,
    this.onSave,
  }) : super(key: key);

  /// The character to edit.
  final Character character;

  /// Either create or update mode.
  final Mode mode;

  /// Callback for save button.
  final OnSave? onSave;

  static const double _kSpacing = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        characterControllerProvider.overrideWithValue(
          CharacterController(initialState: character),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(_kSpacing),
        child: Column(
          children: [
            const Header(),
            if (mode == Mode.create) ...[
              const Gap(_kSpacing * 2),
              const CharacterAvatar(),
            ],
            const Gap(_kSpacing),
            const AttributeListTile<Health>(),
            const AttributeListTile<Attack>(),
            const AttributeListTile<Defense>(),
            const AttributeListTile<Magik>(),
            ActionButtons(onSave: onSave),
          ],
        ),
      ),
    );
  }
}

/// Render character's skills point available
class Header extends ConsumerWidget {
  /// Create [Text] with character skill points.
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsPoints = ref.watch(characterControllerProvider).skills;
    return Text('Skill points available: $skillsPoints');
  }
}

/// Render character's avatar selector.
/// Only available avatars will be displayed.
class CharacterAvatar extends ConsumerWidget {
  /// Create [Row] with [Avatar] in the center and arrows on each side.
  const CharacterAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final avatars = ref.read(avatarsProvider);
    final character = ref.watch(characterControllerProvider);
    final controller = ref.read(characterControllerProvider.notifier);
    final index = avatars.indexWhere(
      (avatar) => avatar.name == character.name,
    );
    final avatar = avatars[index];

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
            key: const Key('previous_avatar'),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: index > 0
                ? () => controller.setName(avatars[index - 1].name)
                : null,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            key: const Key('next_avatar'),
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: index < avatars.length - 1
                ? () => controller.setName(avatars[index + 1].name)
                : null,
          ),
        )
      ],
    );
  }
}

/// Component used to edit given character attribute [T]
class AttributeListTile<T extends Attribute> extends ConsumerWidget {
  /// Create outlined container with attribute label, attribute points
  /// and icon buttons.
  const AttributeListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attribute = ref.watch(characterControllerProvider)<T>();
    final controller = ref.read(characterControllerProvider.notifier);

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
          Expanded(
            child: Text(attribute.label()),
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
                  key: Key('downgrade_${attribute.label()}'),
                  splashRadius: 16,
                  onPressed: controller.canBeDowngraded<T>()
                      ? () => controller.downgrade<T>()
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  key: Key('upgrade_${attribute.label()}'),
                  splashRadius: 16,
                  onPressed: controller.canBeUpgraded<T>()
                      ? () => controller.upgrade<T>()
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Call-to-action buttons.
class ActionButtons extends ConsumerWidget {
  /// Create `RESET` and `SAVE` [TextButton]s
  const ActionButtons({
    Key? key,
    this.onSave,
  }) : super(key: key);

  /// Action to perform on save.
  final OnSave? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          key: const Key('reset_character'),
          style: TextButton.styleFrom(primary: AppColors.gray10),
          onPressed: () {
            ref.read(characterControllerProvider.notifier).refresh();
          },
          child: const Text('RESET'),
        ),
        TextButton(
          key: const Key('save_character'),
          style: TextButton.styleFrom(primary: AppColors.gray10),
          onPressed: () => onSave?.call(ref.read(characterControllerProvider)),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}
