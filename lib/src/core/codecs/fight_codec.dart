import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

class FightCodec extends JsonCodec<Fight> {
  const FightCodec();

  static const _round = RoundCodec();

  @override
  Fight fromMap(Map<String, dynamic> json) {
    return Fight(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      rounds: (json['rounds'] as List<dynamic>)
          .map((dynamic x) => _round.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap(Fight value) {
    return <String, dynamic>{
      'date': value.date.millisecondsSinceEpoch,
      'rounds': value.rounds.map((x) => _round.toMap(x)).toList(),
    };
  }
}
