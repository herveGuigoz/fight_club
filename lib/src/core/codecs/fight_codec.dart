import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

class FightCodec extends JsonCodec<Fight> {
  const FightCodec();

  static const _fightResult = FightResultCodec();

  @override
  Fight fromMap(Map<String, dynamic> json) {
    return Fight(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      result: _fightResult.fromMap(json['result']),
    );
  }

  @override
  Map<String, dynamic> toMap(Fight value) {
    return {
      'date': value.date.millisecondsSinceEpoch,
      'result': _fightResult.toMap(value.result),
    };
  }
}

class FightResultCodec extends JsonCodec<FightResult> {
  const FightResultCodec();

  static const _round = RoundCodec();

  @override
  FightResult fromMap(Map<String, dynamic> json) {
    return FightResult(
      won: json['won'],
      rounds: List<Round>.from(json['rounds']?.map((x) => _round.fromMap(x))),
    );
  }

  @override
  Map<String, dynamic> toMap(FightResult value) {
    return {
      'won': value.won,
      'rounds': value.rounds.map((x) => _round.toMap(x)).toList(),
    };
  }
}
