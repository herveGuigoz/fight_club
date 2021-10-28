import 'dart:convert';

import 'package:fight_club/src/modules/characters/logic/models/attributes.dart';

class Character {
  Character({
    this.level = 1,
    this.skills = 12,
    this.health = const Health(10),
    this.attack = const Attack(0),
    this.defense = const Defense(0),
    this.magik = const Magik(0),
  });

  factory Character.fromJson(String source) {
    return Character.fromMap(json.decode(source));
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      level: map['level'] as int,
      skills: map['skills'] as int,
      health: Health(map['health'] as int),
      attack: Attack(map['attack'] as int),
      defense: Defense(map['defense'] as int),
      magik: Magik(map['magik'] as int),
    );
  }

  final int level;
  final int skills;
  final Health health;
  final Attack attack;
  final Defense defense;
  final Magik magik;

  List<Attribute> get attributes => [health, attack, defense, magik];

  Attribute findAttribute<T extends Attribute>() {
    if (!attributes.any((attribute) => attribute.typeOf<T>())) {
      throw Exception('Attribute of type <$T> Not Found');
    }
    return attributes.firstWhere((attribute) => attribute.typeOf<T>());
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'skills': skills,
      'health': health.value,
      'attack': attack.value,
      'defense': defense.value,
      'magik': magik.value,
    };
  }

  Character decrement(Attribute attribute) {
    return copyWith(
      skills: skills + attribute.skillsPointCosts, // todo: nop
      health: attribute is Health ? Health(health.value - 1) : health,
      attack: attribute is Attack ? Attack(attack.value - 1) : attack,
      defense: attribute is Defense ? Defense(defense.value - 1) : defense,
      magik: attribute is Magik ? Magik(magik.value - 1) : magik,
    );
  }

  Character increment(Attribute attribute) {
    return copyWith(
      skills: skills - attribute.skillsPointCosts,
      health: attribute is Health ? Health(health.value + 1) : health,
      attack: attribute is Attack ? Attack(attack.value + 1) : attack,
      defense: attribute is Defense ? Defense(defense.value + 1) : defense,
      magik: attribute is Magik ? Magik(magik.value + 1) : magik,
    );
  }

  Character copyWith({
    int? level,
    int? skills,
    Health? health,
    Attack? attack,
    Defense? defense,
    Magik? magik,
  }) {
    return Character(
      level: level ?? this.level,
      skills: skills ?? this.skills,
      health: health ?? this.health,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      magik: magik ?? this.magik,
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

extension on Object {
  bool typeOf<T>() => this is T;
}
