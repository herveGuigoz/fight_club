import 'package:fight_club/src/core/data/models/models.dart';

class Round {
  Round({
    required this.id,
    this.diceResult = 0,
    this.damages = 0,
    required this.attacker,
    required this.defender,
  });

  final int id;
  final int diceResult;
  final int damages;
  final Character attacker;
  final Character defender;

  bool get succeed => damages > 0;

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
