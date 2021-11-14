import 'package:fight_club/src/core/codecs/character_codec.dart';
import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

/// JsonCodec implementation for Session model
class SessionCodec extends JsonCodec<Session> {
  /// Provide serialization and deserialization processes for [Session].
  const SessionCodec();

  static const _character = CharacterCodec();

  @override
  Session fromMap(Map<String, dynamic> json) {
    return Session(
      characters: (json['characters'] as List<dynamic>)
          .map((dynamic x) => _character.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap(Session value) {
    return <String, dynamic>{
      'characters': value.characters.map((x) => _character.toMap(x)).toList(),
    };
  }
}
