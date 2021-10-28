import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaracterController extends StateNotifier<Character> {
  CaracterController(Character state) : super(state);

  void decrement<T extends Attribute>() {
    final attribute = state.findAttribute<T>();
  }

  void increment<T extends Attribute>() {
    final attribute = state.findAttribute<T>();

    if (attribute.canBeIncremented(state.skills)) {
      state = state.increment(attribute);
    }
  }
}

class CharacterLayout extends StatelessWidget {
  const CharacterLayout({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [scopedCharacter.overrideWithValue(character)],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0), // todo theme
          child: Column(
            children: character.attributes
                .map((attribute) => AttributeListTile(attribute: attribute))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class AttributeListTile extends ConsumerWidget {
  const AttributeListTile({
    Key? key,
    required this.attribute,
  }) : super(key: key);

  final Attribute attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(scopedCharacter);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: attribute.value > 0
              ? () {
                  // todo
                }
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(attribute.value.toString()),
        IconButton(
          onPressed: attribute.canBeIncremented(character.skills)
              ? () {
                  // todo
                }
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
      ],
    );
  }
}
