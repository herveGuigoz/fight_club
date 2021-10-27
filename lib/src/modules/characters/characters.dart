import 'dart:convert';

class Character {
  Character({
    this.ranking = 1,
    this.skills = 12,
    this.health = 10,
    this.attack = 0,
    this.defense = 0,
    this.magik = 0,
  });

  factory Character.fromJson(String source) {
    return Character.fromMap(json.decode(source));
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      ranking: map['ranking'],
      skills: map['skills'],
      health: map['health'],
      attack: map['attack'],
      defense: map['defense'],
      magik: map['magik'],
    );
  }

  final int ranking;
  final int skills;
  final int health;
  final int attack;
  final int defense;
  final int magik;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'ranking': ranking,
      'skills': skills,
      'health': health,
      'attack': attack,
      'defense': defense,
      'magik': magik,
    };
  }

  Character copyWith({
    int? ranking,
    int? skills,
    int? health,
    int? attack,
    int? defense,
    int? magik,
  }) {
    return Character(
      ranking: ranking ?? this.ranking,
      skills: skills ?? this.skills,
      health: health ?? this.health,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      magik: magik ?? this.magik,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.ranking == ranking &&
        other.skills == skills &&
        other.health == health &&
        other.attack == attack &&
        other.defense == defense &&
        other.magik == magik;
  }

  @override
  int get hashCode {
    return ranking.hashCode ^
        skills.hashCode ^
        health.hashCode ^
        attack.hashCode ^
        defense.hashCode ^
        magik.hashCode;
  }
}
