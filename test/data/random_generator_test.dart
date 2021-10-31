import 'package:fight_club/src/core/data/random_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Random generator', () {
    test('pick a random element from the given list', () {
      final list = List.generate(100, (i) => i);
      final element = Random.element(list);
      expect(list.contains(element), isTrue);
    });

    test('pick a random key from the given map', () {
      final map = Map.fromIterable([1, 2, 3]);
      final key = Random.mapElementKey(map);
      expect(map.keys.contains(key), isTrue);
    });

    test('generates a random integer with the given max value', () {
      final value = Random.integer(2);
      expect(value >= 0 && value <= 2, isTrue);
    });

    test('generates a random integer with the given min value', () {
      final value = Random.integer(2, min: 1);
      expect(value >= 1 && value <= 2, isTrue);
    });

    test('generates a random boolean', () {
      final list = List.generate(20, (_) => Random.boolean());
      expect(list.contains(true), isTrue);
      expect(list.contains(false), isTrue);
    });

    test('a random date', () {
      final lastWeek = DateTime.now().subtract(const Duration(days: 7));
      final dateA = Random.datetime();
      final dateB = Random.datetime();
      expect(dateA != dateB, isTrue);
      expect(dateA.isAfter(lastWeek), isTrue);
      expect(dateB.isAfter(lastWeek), isTrue);
    });
  });
}
