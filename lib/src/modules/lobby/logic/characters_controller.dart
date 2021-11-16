import 'dart:math';

import 'package:fight_club/src/core/data/faker.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/random_generator.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_observer.dart';
import 'package:flutter/foundation.dart';

/// Manage a the list of fake characters
class CharactersController implements FightObserver {
  /// For testing propose, its allowed to inject intial characters.
  CharactersController([this._state = const []]);

  List<Character> _state;

  /// The current characters list.
  @visibleForTesting
  List<Character> get state => _state;

  /// Create [count] random [Character] in isolate.
  /// If [refresh] is true old characters will be replaced.
  Future<List<Character>> getRandomCharacters({
    int count = 1000,
    bool refresh = false,
  }) async {
    if (_state.isEmpty || refresh) {
      _state = await compute(Faker.characters, count);
    }

    return _state;
  }

  /// Choose the right opponent for given [Character]
  ///  - take the closest opponent based on rank value.
  ///  - if several opponents match, take the opponent with the smallest number
  ///    of fights with the character.
  ///  - if several opponents match, take a random opponent within the list.
  Future<Character> findOpponentFor(Character character) async {
    /// Get the initial list of random characters.
    var characters = await getRandomCharacters();

    /// The characters must be able to create or recieved damages.
    characters = characters.whoCanWinOrLooseAgainst(character);

    /// The character must not have loose a fight in the past hour.
    characters = characters.whoDidNotLoosedInPastHour();

    /// If we cant find characters, refresh the state with new ones.
    if (characters.isEmpty) {
      await getRandomCharacters(refresh: true);
      return findOpponentFor(character);
    }

    if (characters.isUnique) return characters.first;

    // Take the closest opponent based on rank value
    final closestOpponentByLevel = characters.getClosestOpponents(
      reference: character.level,
      on: (character) => character.level,
    );
    if (closestOpponentByLevel.isUnique) return closestOpponentByLevel.first;

    /// Take the opponent with the smallest number of fights
    final closestOpponentByFights = closestOpponentByLevel.getClosestOpponents(
      reference: 0,
      on: (character) => character.fights.length,
    );
    if (closestOpponentByFights.isUnique) return closestOpponentByFights.first;

    // Take a random opponent within the list
    return Random.element(closestOpponentByFights);
  }

  @override
  void didFight(Character character, Fight fight) {
    if (!_state.exist(character)) return;

    final didWin = fight.didWin(character);
    saveCharacter(
      character.copyWith(
        skills: didWin ? character.skills + 1 : character.skills,
        level: didWin ? character.level + 1 : max(1, character.level - 1),
        fights: [...character.fights, fight],
      ),
    );
  }

  /// Update character within the list.
  void saveCharacter(Character character) {
    _state = _state.replace(character);
  }
}

extension on List<Character> {
  /// Create new array of characters with only best elements compared to
  /// [reference].
  List<Character> getClosestOpponents({
    required int reference,
    required int Function(Character) on,
  }) {
    final sortedCharacter = mergeSortArray(reference, on, [...this]);
    final bestResult = on(sortedCharacter.first);
    return sortedCharacter
        .takeWhile((character) => on(character) == bestResult)
        .toList();
  }

  /// Filter the characters who cant create or receive damages against [other]
  List<Character> whoCanWinOrLooseAgainst(Character other) {
    return where(
      (character) {
        return character<Attack>().points > other<Defense>().points ||
            other<Attack>().points > character<Defense>().points;
      },
    ).toList();
  }

  /// Filter the characters that lost a fight in the last hour .
  List<Character> whoDidNotLoosedInPastHour() {
    return where((character) => !character.didLooseFightInPastHour()).toList();
  }
}

/// Sorts [array] using merge sort algorithm. [reference] will be use to
/// `compare` other elements with the callback provided by [on] argument.
List<T> mergeSortArray<T>(int reference, int Function(T) on, List<T> array) {
  /// split array until there's only one element
  if (array.length > 1) {
    final middleIndex = (array.length / 2).floor();
    final leftSide = array.getRange(0, middleIndex).toList();
    final rightSide = array.getRange(middleIndex, array.length).toList();
    // call recursively for the left part of the data
    mergeSortArray(reference, on, leftSide);
    // call recursively for the right part of the data
    mergeSortArray(reference, on, rightSide);
    var leftIndex = 0, rightIndex = 0, globalIndex = 0;
    // loop until we reach the end of the left or the right array
    while (leftIndex < leftSide.length && rightIndex < rightSide.length) {
      // actual sort comparaison is here.
      // if the left element is smaller its should be first in the array
      // else the right element should be first. move indexes at each steps
      if (_diff(on(leftSide[leftIndex]), reference) <
          _diff(on(rightSide[rightIndex]), reference)) {
        array[globalIndex] = leftSide[leftIndex];
        leftIndex++;
      } else {
        array[globalIndex] = rightSide[rightIndex];
        rightIndex++;
      }
      globalIndex++;
    }
    // making sure that any element was not left behind during the process
    while (leftIndex < leftSide.length) {
      array[globalIndex] = leftSide[leftIndex];
      leftIndex++;
      globalIndex++;
    }
    while (rightIndex < rightSide.length) {
      array[globalIndex] = rightSide[rightIndex];
      rightIndex++;
      globalIndex++;
    }
  }
  return array;
}

extension on List {
  /// Syntax utility to check if array contains only one item.
  bool get isUnique => length == 1;
}

int _diff(int a, int b) => a >= b ? a - b : b - a;
