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

    late final List<Round> rounds;

    try {
      rounds = await compute(processFight, IsolateEntry(user, opponent));
    } catch (error) {
      throw Exception('Could not process fight: $error');
    }

    final fight = Fight(date: DateTime.now(), rounds: rounds);

    for (final observer in observers) {
      observer.didFight(user, fight);
      observer.didFight(opponent, fight);
    }

    return fight;
  }

  @visibleForTesting
  static List<Round> processFight(IsolateEntry entry) {
    final rounds = <Round>[];
    int roundId = 1;
    Character characterA = entry.characterA;
    Character characterB = entry.characterB;

    while (characterA.health.points > 0 && characterB.health.points > 0) {
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
    if (attacker.attack.points == 0) {
      return Round(id: roundId, attacker: attacker, defender: defender);
    }

    final diceResult = dice.roll(attacker.attack.points);
    int damages = diceResult - defender.defense.points;
    // If the damages equals attacker's magik points amount,
    // this value is added to the damages
    if (damages == attacker.magik.points) {
      damages += attacker.magik.points;
    }

    damages = math.max(0, damages);

    return Round(
      id: roundId,
      diceResult: diceResult,
      damages: damages,
      attacker: attacker,
      defender: defender.copyWith(
        health: math.max(0, defender.health.points - damages),
      ),
    );
  }

  void assertAtLeastOneCharacterCanWin(Character first, Character second) {
    final firstCanWin = first.attack.points > second.defense.points;
    final secondCanWin = second.attack.points > first.defense.points;

    if (!firstCanWin && !secondCanWin) throw FightException();
  }
}

class Dice {
  const Dice();

  int roll(int max) => Random.integer(max, min: 1);
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
