import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:fight_club/src/core/data/models/models.dart';

class Fight extends Model {
  Fight({
    String? id,
    required this.date,
    this.rounds = const [],
  }) : super(id ?? const Uuid().v4());

  final DateTime date;
  final List<Round> rounds;

  bool didWin(Character character) {
    if (rounds.isEmpty) return false;
    return rounds.last.attacker.id == character.id;
  }

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

class FightResult {
  FightResult({
    required this.character,
    required this.opponent,
    required this.didWin,
    required this.fight,
  });

  final Character character;
  final Character opponent;
  final bool didWin;
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
