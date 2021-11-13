import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Unique object that store fight history.
@immutable
class Fight extends Model {
  /// A [Fight] is representing by a date and rounds history.
  Fight({
    String? id,
    required this.date,
    this.rounds = const [],
  }) : super(id ?? const Uuid().v4());

  /// The date on which the fight took place.
  final DateTime date;

  /// The [Round] collection.
  final List<Round> rounds;

  /// Find the identifier of the last fighter who attacked and returns if it
  /// matches given [Character]'s id.
  bool didWin(Character character) {
    if (rounds.isEmpty) return false;
    return rounds.last.attacker.id == character.id;
  }

  /// Clone this object with different values.
  Fight copyWith({DateTime? date, List<Round>? rounds}) {
    return Fight(date: date ?? this.date, rounds: rounds ?? this.rounds);
  }

  @override
  String toString() => 'Fight(date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Fight &&
        other.date == date &&
        listEquals(other.rounds, rounds);
  }

  @override
  int get hashCode => date.hashCode ^ rounds.hashCode;
}

/// Value object of [Fight] details.
@immutable
class FightResult {
  /// Gives the result of a fight after it has been processed.
  const FightResult({
    required this.character,
    required this.opponent,
    required this.didWin,
    required this.fight,
  });

  /// The character who launched the fight
  final Character character;

  /// The character who has been chosen as the opponent.
  final Character opponent;

  /// The resut for the character who launched the fight.
  final bool didWin;

  /// The fight details.
  final Fight fight;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FightResult &&
        other.character == character &&
        other.opponent == opponent &&
        other.didWin == didWin &&
        other.fight == fight;
  }

  @override
  int get hashCode {
    return character.hashCode ^
        opponent.hashCode ^
        didWin.hashCode ^
        fight.hashCode;
  }
}
