import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';

class CharacterCodec extends JsonCodec<Character> {
  const CharacterCodec();

  // static const _fight = FightCodec();

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
      fights: [],
      // fights: List<Fight>.from(json['fights']?.map((x) => _fight.fromMap(x))),
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
      // 'fights': value.fights.map((x) => _fight.toMap(x)).toList(),
    };
  }
}
