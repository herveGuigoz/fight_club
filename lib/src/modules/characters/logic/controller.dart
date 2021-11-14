import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logic for editing charater's attributes.
/// Attribute could be upgraded by one only if has enought skills points.
/// Attribute could be downgraded by one only if attribute was previously
/// modified.
class CharacterController extends StateNotifier<Character> {
  /// Initialize [state]
  CharacterController({required this.initialState}) : super(initialState);

  /// The initial character attributes.
  final Character initialState;

  /// Discard all changes.
  void refresh() => state = initialState;

  /// Update character avatar.
  void setName(String name) {
    state = state.copyWith(name: name);
  }

  /// Remove one point on given [Attribute] and update the skills accordingly.
  void downgrade<T extends Attribute>() {
    if (canBeDowngraded<T>()) {
      state = state.downgrade<T>();
    }
  }

  /// Add one point on given [Attribute] and update the skills accordingly.
  void upgrade<T extends Attribute>() {
    if (canBeUpgraded<T>()) {
      state = state.upgrade<T>();
    }
  }

  /// Returns true if the character has enough skills to increase the attribute.
  bool canBeUpgraded<T extends Attribute>() {
    return state<T>().skillsCost <= state.skills;
  }

  /// Returns true if the character did update the attribute.
  bool canBeDowngraded<T extends Attribute>() {
    return state<T>().points > initialState<T>().points;
  }
}
