// ignore_for_file: lines_longer_than_80_chars

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:meta/meta.dart';

/// Unique object that store round result.
@immutable
class Round {
  /// A fight produce rounds until one of the characters has no more health
  /// points. The last character who attacked will be the winner.
  const Round({
    required this.id,
    this.diceResult = 0,
    this.damages = 0,
    required this.attacker,
    required this.defender,
  });

  /// Index in the rounds list.
  final int id;

  /// The random number returned by the dice.
  final int diceResult;

  /// The computation of health point to substract based on dice's result,
  /// defender's defense trait and both attacker's attack and attacker's
  /// magik traits.
  final int damages;

  /// The character who run an attack during this round.
  final Character attacker;

  /// The character who defends during this round.
  final Character defender;

  /// Returns true if the attack caused damage.
  bool get succeed => damages > 0;

  /// Clone this object with different values.
  Round copyWith({
    int? id,
    int? diceResult,
    int? damages,
    Character? attacker,
    Character? defender,
  }) {
    return Round(
      id: id ?? this.id,
      diceResult: diceResult ?? this.diceResult,
      damages: damages ?? this.damages,
      attacker: attacker ?? this.attacker,
      defender: defender ?? this.defender,
    );
  }

  @override
  String toString() {
    return 'Round(id: $id, diceResult: $diceResult, damages: $damages, defender: $defender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Round &&
        other.id == id &&
        other.diceResult == diceResult &&
        other.damages == damages &&
        other.attacker == attacker &&
        other.defender == defender;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        diceResult.hashCode ^
        damages.hashCode ^
        attacker.hashCode ^
        defender.hashCode;
  }
}
