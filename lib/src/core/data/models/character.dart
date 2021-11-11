import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:fight_club/src/core/data/models/models.dart';

const kDefaultSkillsPoints = 12;
const kDefaultHealthPoints = 10;

class Character extends Model {
  Character({
    String? id,
    this.name = 'Anonymous',
    this.level = 1,
    this.skills = kDefaultSkillsPoints,
    int health = kDefaultHealthPoints,
    int attack = 0,
    int defense = 0,
    int magik = 0,
    this.fights = const [],
  })  : attributes = {
          Health: Health(health),
          Attack: Attack(attack),
          Defense: Defense(defense),
          Magik: Magik(magik)
        },
        super(id ?? const Uuid().v4());

  /// Private constructor used to upgrade/downgrade attributes.
  Character._({
    required String id,
    required this.name,
    required this.level,
    required this.skills,
    required this.attributes,
    required this.fights,
  }) : super(id);

  final String name;
  final int level;
  final int skills;
  final Map<Type, Attribute> attributes;
  final List<Fight> fights;

  /// Shortcut for character.getAttribute<T>()
  /// ```dart
  ///   final character = Character();
  ///   final attribute = character<Health>();
  /// ```
  /// equals
  /// ```dart
  ///   final character = Character();
  ///   final attribute = character.getAttribute<Health>();
  /// ```
  Attribute call<T extends Attribute>() => getAttribute<T>();

  /// Retrieve [Attribute] of type [T]
  Attribute getAttribute<T extends Attribute>() {
    if (!attributes.containsKey(typeOf<T>())) {
      throw AttributeNotFoundException<T>();
    }
    return attributes[typeOf<T>()]!;
  }

  Fight? get lastFight {
    if (fights.isNotEmpty) {
      return (fights..sort((a, b) => a.date.compareTo(b.date))).last;
    }
  }

  bool didLooseFightInPastHour() {
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    final didFight = lastFight?.date.isAfter(oneHourAgo) ?? false;

    return didFight && !lastFight!.didWin(this);
  }

  /// Return a copy of this character with attribute of type [T] downgraded
  /// by one and skills updated accordingly.
  Character downgrade<T extends Attribute>() {
    final current = getAttribute<T>();
    final update = current.copyWith(points: current.points - 1);
    assert(update.points >= 0);

    return Character._(
      id: id,
      name: name,
      level: level,
      skills: skills + update.skillsCost,
      attributes: Map.from(attributes)..update(typeOf<T>(), (_) => update),
      fights: fights,
    );
  }

  /// Return a copy of this character with attribute of type [T] upgraded
  /// by one and skills updated accordingly.
  Character upgrade<T extends Attribute>() {
    final current = getAttribute<T>();
    final update = current.copyWith(points: current.points + 1);
    assert(skills >= current.skillsCost);

    return Character._(
      id: id,
      name: name,
      level: level,
      skills: skills - current.skillsCost,
      attributes: Map.from(attributes)..update(typeOf<T>(), (_) => update),
      fights: fights,
    );
  }

  Character copyWith({
    String? id,
    String? name,
    int? level,
    int? skills,
    int? health,
    int? attack,
    int? defense,
    int? magik,
    List<Fight>? fights,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      skills: skills ?? this.skills,
      health: health ?? getAttribute<Health>().points,
      attack: attack ?? getAttribute<Attack>().points,
      defense: defense ?? getAttribute<Defense>().points,
      magik: magik ?? getAttribute<Magik>().points,
      fights: fights ?? this.fights,
    );
  }

  @override
  String toString() {
    return 'Character(name: $name, level: $level, skills: $skills, attributes: ${attributes.values})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.level == level &&
        other.skills == skills &&
        mapEquals(other.attributes, attributes) &&
        listEquals(other.fights, fights);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        level.hashCode ^
        skills.hashCode ^
        attributes.hashCode ^
        fights.hashCode;
  }
}

Type typeOf<T>() => T;

class AttributeNotFoundException<T extends Attribute> implements Exception {
  @override
  String toString() => 'Undefine attribute of type $T';
}
