import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logic for editing charater's attributes.
/// Attribute could be upgraded by one only if has enought skills points.
/// Attribute could be downgraded by one only if attribute was previously
/// modified.
class CharacterController extends StateNotifier<Character> {
  CharacterController({
    required this.initialState,
  }) : super(initialState);

  final Character initialState;

  void refresh() => state = initialState;

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void downgrade<T extends Attribute>() {
    if (canBeDowngraded<T>()) {
      state = state.downgrade<T>();
    }
  }

  void upgrade<T extends Attribute>() {
    if (canBeUpgraded<T>()) {
      state = state.upgrade<T>();
    }
  }

  bool canBeUpgraded<T extends Attribute>() {
    return state<T>().skillsCost <= state.skills;
  }

  bool canBeDowngraded<T extends Attribute>() {
    return state<T>().points > initialState<T>().points;
  }
}
