import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fight_club/src/modules/characters/characters.dart';

/// Logic for editing charater's attributes.
/// Attribute could be upgraded by one only if has enought skills points.
/// Attribute could be downgraded by one only if previously modified.
class CharacterController extends StateNotifier<CharacterChanges> {
  CharacterController({
    required Character character,
  }) : super(CharacterChanges(character));

  @protected
  Health get health => state.character.health;
  @protected
  Attack get attack => state.character.attack;
  @protected
  Defense get defense => state.character.defense;
  @protected
  Magik get magik => state.character.magik;

  static bool canBeUpgraded(Character character, Attribute attribute) {
    return attribute.skillsPointCosts <= character.skills;
  }

  void downgrade(Attribute attribute) {
    if (!state.changes.contains(attribute)) {
      throw CharacterDowngradeException(state.character, attribute);
    }

    final character = state.character.copyWith(
      skills: state.character.skills + attribute.skillsPointCosts,
      health: attribute is Health ? health - 1 : health.points,
      attack: attribute is Attack ? attack - 1 : attack.points,
      defense: attribute is Defense ? defense - 1 : defense.points,
      magik: attribute is Magik ? magik - 1 : magik.points,
    );

    state = state.copyWith(
      character: character,
      changes: [...state.changes]..remove(attribute),
    );
  }

  void upgrade(Attribute attribute) {
    if (!canBeUpgraded(state.character, attribute)) {
      throw CharacterUpgradeException(state.character, attribute);
    }

    final character = state.character.copyWith(
      skills: state.character.skills - attribute.skillsPointCosts,
      health: attribute is Health ? health + 1 : health.points,
      attack: attribute is Attack ? attack + 1 : attack.points,
      defense: attribute is Defense ? defense + 1 : defense.points,
      magik: attribute is Magik ? magik + 1 : magik.points,
    );

    state = state.copyWith(
      character: character,
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
