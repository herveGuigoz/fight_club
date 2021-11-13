import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/round.dart';

/// JsonCodec implementation for Round model
class RoundCodec extends JsonCodec<Round> {
  /// Provide serialization and deserialization processes for [Round].
  const RoundCodec();

  static const _character = CharacterCodec();

  @override
  Round fromMap(Map<String, dynamic> json) {
    return Round(
      id: json['id'] as int,
      diceResult: json['diceResult'] as int,
      damages: json['damages'] as int,
      attacker: _character.fromMap(json['attacker'] as Map<String, dynamic>),
      defender: _character.fromMap(json['defender'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toMap(Round value) {
    return <String, dynamic>{
      'id': value.id,
      'diceResult': value.diceResult,
      'damages': value.damages,
      'attacker': _character.toMap(value.attacker),
      'defender': _character.toMap(value.defender),
    };
  }
}
