import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

import 'character_codec.dart';

class SessionCodec extends JsonCodec<Session> {
  const SessionCodec();

  static const _character = CharacterCodec();

  @override
  Session fromMap(Map<String, dynamic> json) {
    return Session(
      characters: List<Character>.from(
        json['characters']?.map((x) => _character.fromMap(x)),
      ),
    );
  }

  @override
  Map<String, dynamic> toMap(Session value) {
    return {
      'characters': value.characters.map((x) => _character.toMap(x)).toList(),
    };
  }
}
