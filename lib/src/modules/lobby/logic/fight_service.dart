import 'dart:math' as math;

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/random_generator.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_observer.dart';
import 'package:flutter/foundation.dart';

class FightService {
  FightService({
    this.observers = const [],
  });

  final List<FightObserver> observers;

  @visibleForTesting
  static Dice dice = const Dice();

  /// Run fight in isolate.
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

  void assertAtLeastOneCharacterCanWin(Character first, Character second) {
    final firstCanWin = first<Attack>().points > second<Defense>().points;
    final secondCanWin = second<Attack>().points > first<Defense>().points;

    if (!firstCanWin && !secondCanWin) throw FightException();
  }
}

class Dice {
  const Dice();

  /// Generates a random integer between 1 ~ max (inclusive).
  int roll(int max) => Random.integer(max + 1, min: 1);
}

class IsolateEntry {
  IsolateEntry(this.characterA, this.characterB);

  final Character characterA;
  final Character characterB;
}

class FightException implements Exception {
  @override
  String toString() {
    return 'Fight could not be processed, both characters cant attack';
  }
}
