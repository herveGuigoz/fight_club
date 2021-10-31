import 'package:fight_club/src/core/codecs/json_codec.dart';
import 'package:fight_club/src/modules/characters/logic/models/attributes.dart';
import 'package:uuid/uuid.dart';

/// Imutable data class
abstract class Model {
  const Model(this.id);

  final String id;
}

class Character extends Model {
  Character({
    String? id,
    this.level = 1,
    this.skills = 12,
    int health = 10,
    int attack = 0,
    int defense = 0,
    int magik = 0,
  })  : health = Health(health),
        attack = Attack(attack),
        defense = Defense(defense),
        magik = Magik(magik),
        super(id ?? const Uuid().v4());

  final int level;
  final int skills;
  final Health health;
  final Attack attack;
  final Defense defense;
  final Magik magik;

  List<Attribute> get attributes => [health, attack, defense, magik];

  Character copyWith({
    int? level,
    int? skills,
    int? health,
    int? attack,
    int? defense,
    int? magik,
  }) {
    return Character(
      level: level ?? this.level,
      skills: skills ?? this.skills,
      health: health ?? this.health.points,
      attack: attack ?? this.attack.points,
      defense: defense ?? this.defense.points,
      magik: magik ?? this.magik.points,
    );
  }

  @override
  String toString() {
    return 'Character(level: $level, skills: $skills, attributes: $health, $attack, $defense, $magik)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.level == level &&
        other.skills == skills &&
        other.health == health &&
        other.attack == attack &&
        other.defense == defense &&
        other.magik == magik;
  }

  @override
  int get hashCode {
    return level.hashCode ^
        skills.hashCode ^
        health.hashCode ^
        attack.hashCode ^
        defense.hashCode ^
        magik.hashCode;
  }
}

class CharacterCodec extends JsonCodec<Character> {
  const CharacterCodec();

  @override
  Map<String, dynamic> toMap(Character value) {
    return {
      'id': value.id,
      'level': value.level,
      'skills': value.skills,
      'health': value.health.points,
      'attack': value.attack.points,
      'defense': value.defense.points,
      'magik': value.magik.points,
    };
  }

  @override
  Character fromMap(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      level: json['level'] as int,
      skills: json['skills'] as int,
      health: json['health'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      magik: json['magik'] as int,
    );
  }
}
