import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/round.dart';

class RoundCodec extends JsonCodec<Round> {
  const RoundCodec();

  static const _character = CharacterCodec();

  @override
  Round fromMap(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      diceResult: json['diceResult'],
      damages: json['damages'],
      attacker: _character.fromMap(json['attacker']),
      defender: _character.fromMap(json['defender']),
    );
  }

  @override
  Map<String, dynamic> toMap(Round value) {
    return {
      'id': value.id,
      'diceResult': value.diceResult,
      'damages': value.damages,
      'attacker': _character.toMap(value.attacker),
      'defender': _character.toMap(value.defender),
    };
  }
}
