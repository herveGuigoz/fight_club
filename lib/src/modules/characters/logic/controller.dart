import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logic for editing charater's attributes.
/// Attribute could be upgraded by one only if has enought skills points.
/// Attribute could be downgraded by one only if previously modified.
class CharacterController extends StateNotifier<Character> {
  CharacterController({
    required this.initialState,
  }) : super(initialState);

  final Character initialState;

  bool canBeUpgraded(Attribute attribute) {
    return attribute.skillsPointCosts <= state.skills;
  }

  bool canBeDowngraded(Attribute attribute) {
    final initial = initialState.attributes.firstWhereSameTypeAs(attribute);
    final current = state.attributes.firstWhereSameTypeAs(attribute);

    return current.points > initial.points;
  }

  void refresh() => state = initialState;

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void downgrade(Attribute value) {
    if (canBeDowngraded(value)) {
      state = state - state.attributes.firstWhereSameTypeAs(value);
    }
  }

  void upgrade(Attribute attribute) {
    if (canBeUpgraded(attribute)) {
      state = state + attribute;
    }
  }
}

extension AttributeTypeExtension on Attribute {
  bool sameTypeAs(Attribute other) => runtimeType == other.runtimeType;
}

extension IterableAttributeExtension on List<Attribute> {
  Attribute firstWhereSameTypeAs(Attribute other) {
    return firstWhere((attribute) => attribute.sameTypeAs(other));
  }
}
