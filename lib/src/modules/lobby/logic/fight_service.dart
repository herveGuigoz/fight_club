import 'dart:math' as math;

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/random_generator.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_observer.dart';
import 'package:flutter/foundation.dart';

/// Service to process fight and notify observers.
class FightService {
  /// initialize list of [FightObserver]
  FightService({
    this.observers = const [],
  });

  /// The fights listeners.
  final List<FightObserver> observers;

  /// Random integer generator.
  @visibleForTesting
  static Dice dice = const Dice();

  /// Process new fight in isolate and notify observers.
  /// @throw FightException if both characters can't win.
  Future<Fight> launchFight(Character user, Character opponent) async {
    assertAtLeastOneCharacterCanWin(user, opponent);

    final rounds = await compute(processFight, IsolateEntry(user, opponent));

    final fight = Fight(date: DateTime.now(), rounds: rounds);

    for (final observer in observers) {
      observer
        ..didFight(user, fight)
        ..didFight(opponent, fight);
    }

    return fight;
  }

  /// Produce rounds until one of the characters has no more health points.
  /// The last character who attacked will be the winner.
  @visibleForTesting
  static List<Round> processFight(IsolateEntry entry) {
    final rounds = <Round>[];
    var roundId = 1;
    var characterA = entry.characterA;
    var characterB = entry.characterB;

    while (characterA<Health>().points > 0 && characterB<Health>().points > 0) {
      late final Round roundResult;

      if (roundId.isOdd) {
        roundResult = processRound(roundId, characterA, characterB);
        characterB = roundResult.defender;
      } else {
        roundResult = processRound(roundId, characterB, characterA);
        characterA = roundResult.defender;
      }

      rounds.add(roundResult);
      roundId++;
    }

    return rounds;
  }

  /// Roll a dice with as many faces as the [attacker]'s [Attack] attribute,
  /// and compare the result with [defender]'s [Defense] attribute to compute
  /// the round damages.
  /// Return a [Round] with [defender]'s [Health] updated.
  @visibleForTesting
  static Round processRound(
    int roundId,
    Character attacker,
    Character defender,
  ) {
    if (attacker<Attack>().points == 0) {
      return Round(id: roundId, attacker: attacker, defender: defender);
    }

    final diceResult = dice.roll(attacker<Attack>().points);
    var damages = diceResult - defender<Defense>().points;
    // If the damages equals attacker's magik points amount,
    // this value is added to the damages
    if (damages == attacker<Magik>().points) {
      damages += attacker<Magik>().points;
    }

    damages = math.max(0, damages);

    return Round(
      id: roundId,
      diceResult: diceResult,
      damages: damages,
      attacker: attacker,
      defender: defender.copyWith(
        health: math.max(0, defender<Health>().points - damages),
      ),
    );
  }

  /// Throw [FightException] to avoid infinite loop on a fight where both
  /// character cant create damages on each other.
  void assertAtLeastOneCharacterCanWin(Character first, Character second) {
    final firstCanWin = first<Attack>().points > second<Defense>().points;
    final secondCanWin = second<Attack>().points > first<Defense>().points;

    if (!firstCanWin && !secondCanWin) throw FightException();
  }
}

/// Dice roller.
class Dice {
  /// Create a dice roller.
  const Dice();

  /// Generates a random integer between 1 ~ max (inclusive).
  int roll(int max) => Random.integer(max + 1, min: 1);
}

/// Store fighter informations.
class IsolateEntry {
  /// Arguments for processing a fight on isolate.
  IsolateEntry(this.characterA, this.characterB);

  /// The first character to attack.
  final Character characterA;

  /// The first character to defend.
  final Character characterB;
}

/// Thrown when characters cant create damages on each other.
class FightException implements Exception {
  @override
  String toString() {
    return 'Fight could not be processed, both characters cant attack';
  }
}
