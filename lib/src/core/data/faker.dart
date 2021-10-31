import 'dart:math' as math;
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/random_generator.dart';

/// Service to generates fake data.
class Faker {
  /// Generates a fake [Fight].
  static Fight fight() {
    return Fight(
      date: Random.datetime(),
      result: FightResult(won: Random.boolean(), rounds: []),
    );
  }

  /// Generates new list of fake characters.
  static List<Character> characters(int count) {
    final characters = <Character>[];

    for (var i = 0; i < count; i++) {
      characters.add(character());
    }

    return characters;
  }

  /// Generates a fake [Character].
  static Character character({int maxFightsCount = 100}) {
    // create fake fights
    final fights = List.generate(
      Random.integer(maxFightsCount, min: 1),
      (_) => fight(),
    );

    // compute number of wins
    final wins = fights.fold<int>(
      0,
      (count, fight) => fight.result.won ? count + 1 : count,
    );

    // compute number of losses
    final losses = fights.length - wins;

    // compute overall number of skills
    int skillsCount = 12 + wins;

    // assign randomly one point per skills count
    final attributes = <String, int>{
      'health': 10,
      'attack': 0,
      'defense': 0,
      'magik': 0
    };
    for (var i = 0; i < skillsCount; i++) {
      final key = Random.mapElementKey(attributes);
      attributes[key] = attributes[key]! + 1;
    }

    return Character(
      level: math.max(1, wins - losses),
      skills: 0,
      health: attributes['health'] as int,
      attack: attributes['attack'] as int,
      defense: attributes['defense'] as int,
      magik: attributes['magik'] as int,
      fights: fights,
    );
  }
}
