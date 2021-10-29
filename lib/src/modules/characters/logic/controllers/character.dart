import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// todo: order price and current price on Attribute.
// todo: then keep map<Type, List<Attribute>> on Character to allow dismiss
// todo: attribute
class CharacterLogic extends StateNotifier<Character> {
  CharacterLogic({Character? character}) : super(character ?? Character());

  static bool canBeIncremented(Character character, Attribute attribute) {
    return attribute.skillsPointCosts <= character.skills;
  }

  void increment(Attribute attribute) {
    if (!canBeIncremented(state, attribute)) {
      throw CharacterLogicException(state, attribute);
    }

    state = state.copyWith(
      skills: state.skills - attribute.skillsPointCosts,
      health: attribute is Health ? state.health + 1 : state.health.points,
      attack: attribute is Attack ? state.attack + 1 : state.attack.points,
      defense: attribute is Defense ? state.defense + 1 : state.defense.points,
      magik: attribute is Magik ? state.magik + 1 : state.magik.points,
    );
  }
}

class CharacterLogicException implements Exception {
  CharacterLogicException(this.character, this.attribute);

  final Character character;
  final Attribute attribute;

  @override
  String toString() {
    return 'Could not increment $attribute on $character.'
        'Ensure that character has enought skills to increment this value:'
        'Increasing 1 point costs ${attribute.skillsPointCosts} skills amount';
  }
}
