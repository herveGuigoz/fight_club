import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logic for editing charater's attributes.
/// Attribute could be upgraded by one only if has enought skills points.
/// Attribute could be downgraded by one only if previously modified.
class CharacterController extends StateNotifier<CharacterChanges> {
  CharacterController({
    required Character character,
  }) : super(CharacterChanges(character));

  static bool canBeUpgraded(Character character, Attribute attribute) {
    return attribute.skillsPointCosts <= character.skills;
  }

  void downgrade(Attribute value) {
    if (!state.changes.any((el) => el.sameTypeAs(value))) {
      throw CharacterDowngradeException(state.character, value);
    }

    final attribute = state.changes.where((el) => el.sameTypeAs(value)).last;

    state = state.copyWith(
      character: state.character - attribute,
      changes: [...state.changes]..remove(attribute),
    );
  }

  void upgrade(Attribute attribute) {
    if (!canBeUpgraded(state.character, attribute)) {
      throw CharacterUpgradeException(state.character, attribute);
    }

    state = state.copyWith(
      character: state.character + attribute,
      changes: [...state.changes, attribute],
    );
  }
}

/// Store edited character and his new attributes.
class CharacterChanges {
  CharacterChanges(this.character, {this.changes = const []});

  final Character character;
  final List<Attribute> changes;

  CharacterChanges copyWith({Character? character, List<Attribute>? changes}) {
    return CharacterChanges(
      character ?? this.character,
      changes: changes ?? this.changes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterChanges &&
        other.character == character &&
        listEquals(other.changes, changes);
  }

  @override
  int get hashCode => character.hashCode ^ changes.hashCode;

  @override
  String toString() => 'CharacterChanges($character, changes: $changes)';
}

class CharacterUpgradeException implements Exception {
  CharacterUpgradeException(this.character, this.attribute);

  final Character character;
  final Attribute attribute;

  @override
  String toString() {
    return 'Could not upgrade $attribute on $character.'
        'Ensure that character has enought skills to upgrade this value:'
        'Increasing 1 point costs ${attribute.skillsPointCosts} skills amount';
  }
}

class CharacterDowngradeException implements Exception {
  CharacterDowngradeException(this.character, this.attribute);

  final Character character;
  final Attribute attribute;

  @override
  String toString() {
    return 'Could not downgrade $attribute on $character.'
        'This is most likely because any attribute of type'
        '${attribute.runtimeType} where previously upgraded.';
  }
}

extension on Attribute {
  bool sameTypeAs(Attribute other) => runtimeType == other.runtimeType;
}
