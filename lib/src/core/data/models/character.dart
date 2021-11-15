import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Character's default skills value
const kDefaultSkillsPoints = 12;

/// Character's default health value
const kDefaultHealthPoints = 10;

/// Unique object that can fight.
@immutable
class Character extends Model {
  /// Public constructor with default characteristics.
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
  const Character._({
    required String id,
    required this.name,
    required this.level,
    required this.skills,
    required this.attributes,
    required this.fights,
  }) : super(id);

  /// The name of this character.
  /// Must be linked to existing avatar.
  final String name;

  /// Define how the character perfomed during his fights.
  /// Will be increased after a win and decreased after a loose, but should
  /// always be equal or greater than one.
  final int level;

  /// Exchange money to increase an attribute.
  /// Must be incremented by one after a win.
  final int skills;

  /// Collection of Type/Attribute pairs.
  final Map<Type, Attribute> attributes;

  /// The history of [Fight]
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
    if (!attributes.containsKey(_typeOf<T>())) {
      throw AttributeNotFoundException<T>();
    }
    return attributes[_typeOf<T>()]!;
  }

  /// Sort characters fight history by date and retrieve the last one if any.
  Fight? get lastFight {
    if (fights.isNotEmpty) {
      return (fights..sort((a, b) => a.date.compareTo(b.date))).last;
    }
  }

  /// Find out if the character has lost a fight in the last hour.
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

    assert(
      update.points >= 0,
      "It's not allowed to downgrade attribute $T",
    );

    return Character._(
      id: id,
      name: name,
      level: level,
      skills: skills + update.skillsCost,
      attributes: Map.from(attributes)..update(_typeOf<T>(), (_) => update),
      fights: fights,
    );
  }

  /// Return a copy of this character with attribute of type [T] upgraded
  /// by one and skills updated accordingly.
  Character upgrade<T extends Attribute>() {
    final current = getAttribute<T>();
    final update = current.copyWith(points: current.points + 1);

    assert(
      skills >= current.skillsCost,
      "It's not allowed to upgrade attribute $T",
    );

    return Character._(
      id: id,
      name: name,
      level: level,
      skills: skills - current.skillsCost,
      attributes: Map.from(attributes)..update(_typeOf<T>(), (_) => update),
      fights: fights,
    );
  }

  /// Clone character with different values.
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
    // ignore: lines_longer_than_80_chars
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

/// Thrown when trying to find out an attribute on character that do not exist.
class AttributeNotFoundException<T extends Attribute> implements Exception {
  @override
  String toString() => 'Undefine attribute of type $T';
}

Type _typeOf<T>() => T;
