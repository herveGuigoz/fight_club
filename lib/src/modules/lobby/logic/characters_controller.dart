import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/data/faker.dart';
import 'package:fight_club/src/core/data/random_generator.dart';
import 'package:flutter/foundation.dart';

/// Manage a the list of 1000 fake characters
class CaractersController {
  CaractersController();

  @protected
  List<Character> state = [];

  /// Create random [Character] in isolate.
  Future<List<Character>> getRandomCharacters({int count = 1000}) async {
    if (state.isEmpty) {
      state = await compute(Faker.characters, count);
    }

    return state;
  }

  Future<Character> findOpponentFor(Character character) async {
    /// List of random characters.
    final characters = await getRandomCharacters();

    /// The character has to be free (it must not have fight in the past hour)
    // todo throw exception if empty
    final availableCharacters = characters
        .where((character) => !character.didLooseFightInPastHour())
        .toList();
    if (availableCharacters.isUnique) return availableCharacters.first;

    // Take the closest opponent based on rank value
    final closestOpponentByLevel = availableCharacters.getClosestOpponents(
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

  void saveCharacter(Character character) {
    state = state.map((it) => it.id == character.id ? character : it).toList();
  }
}

extension SortExtension on List<Character> {
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

/// Syntax utility to check if array contains only one item.
extension IterableExt<T> on List<T> {
  bool get isUnique => length == 1;
}

int _diff(int a, int b) => a >= b ? a - b : b - a;
