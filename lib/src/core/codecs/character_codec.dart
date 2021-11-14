import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

/// JsonCodec implementation for Character model
class CharacterCodec extends JsonCodec<Character> {
  /// Provide serialization and deserialization processes for [Character].
  const CharacterCodec();

  @override
  Character fromMap(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      skills: json['skills'] as int,
      health: json['health'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      magik: json['magik'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap(Character value) {
    return <String, dynamic>{
      'id': value.id,
      'name': value.name,
      'level': value.level,
      'skills': value.skills,
      'health': value<Health>().points,
      'attack': value<Attack>().points,
      'defense': value<Defense>().points,
      'magik': value<Magik>().points,
    };
  }
}
