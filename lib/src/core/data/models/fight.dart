import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:fight_club/src/core/data/models/models.dart';

class Fight extends Model {
  Fight({
    String? id,
    required this.date,
    required this.result,
  }) : super(id ?? const Uuid().v4());

  final DateTime date;
  final FightResult result;

  Fight copyWith({DateTime? date, FightResult? result}) {
    return Fight(date: date ?? this.date, result: result ?? this.result);
  }

  @override
  String toString() => 'Fight(date: $date, result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Fight && other.date == date && other.result == result;
  }

  @override
  int get hashCode => date.hashCode ^ result.hashCode;
}

class FightResult {
  FightResult({
    required this.won,
    required this.rounds,
  });

  final bool won;
  final List<Round> rounds;

  FightResult copyWith({bool? won, List<Round>? rounds}) {
    return FightResult(won: won ?? this.won, rounds: rounds ?? this.rounds);
  }

  @override
  String toString() => 'FightResult(won: $won, rounds: $rounds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FightResult &&
        other.won == won &&
        listEquals(other.rounds, rounds);
  }

  @override
  int get hashCode => won.hashCode ^ rounds.hashCode;
}
