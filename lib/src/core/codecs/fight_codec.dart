import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

class FightCodec extends JsonCodec<Fight> {
  const FightCodec();

  static const _round = RoundCodec();

  @override
  Fight fromMap(Map<String, dynamic> json) {
    return Fight(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      rounds: List<Round>.from(json['rounds']?.map((x) => _round.fromMap(x))),
    );
  }

  @override
  Map<String, dynamic> toMap(Fight value) {
    return {
      'date': value.date.millisecondsSinceEpoch,
      'rounds': value.rounds.map((x) => _round.toMap(x)).toList(),
    };
  }
}
