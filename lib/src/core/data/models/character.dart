import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:fight_club/src/core/data/models/models.dart';

class Character extends Model {
  Character({
    String? id,
    this.level = 1,
    this.skills = 12,
    int health = 10,
    int attack = 0,
    int defense = 0,
    int magik = 0,
    this.fights = const [],
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
  final List<Fight> fights;

  List<Attribute> get attributes => [health, attack, defense, magik];

  Fight? get lastFight {
    if (fights.isNotEmpty) {
      return (fights..sort((a, b) => a.date.compareTo(b.date))).last;
    }
  }

  bool didLoosedInLast24hours() {
    return lastFight?.date.isBefore(DateTime.now()) ?? false;
  }

  Character copyWith({
    int? level,
    int? skills,
    int? health,
    int? attack,
    int? defense,
    int? magik,
    List<Fight>? fights,
  }) {
    return Character(
      level: level ?? this.level,
      skills: skills ?? this.skills,
      health: health ?? this.health.points,
      attack: attack ?? this.attack.points,
      defense: defense ?? this.defense.points,
      magik: magik ?? this.magik.points,
      fights: fights ?? this.fights,
    );
  }

  @override
  String toString() {
    return 'Character(level: $level, skills: $skills, attributes: $health, $attack, $defense, $magik)';
  }

  Character operator +(Attribute attribute) {
    return copyWith(
      skills: skills - attribute.skillsPointCosts,
      health: attribute is Health ? health + 1 : health.points,
      attack: attribute is Attack ? attack + 1 : attack.points,
      defense: attribute is Defense ? defense + 1 : defense.points,
      magik: attribute is Magik ? magik + 1 : magik.points,
    );
  }

  Character operator -(Attribute attribute) {
    return copyWith(
      skills: skills + attribute.skillsPointCosts,
      health: attribute is Health ? health - 1 : health.points,
      attack: attribute is Attack ? attack - 1 : attack.points,
      defense: attribute is Defense ? defense - 1 : defense.points,
      magik: attribute is Magik ? magik - 1 : magik.points,
    );
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
        other.magik == magik &&
        listEquals(other.fights, fights);
  }

  @override
  int get hashCode {
    return level.hashCode ^
        skills.hashCode ^
        health.hashCode ^
        attack.hashCode ^
        defense.hashCode ^
        magik.hashCode ^
        fights.hashCode;
  }
}
