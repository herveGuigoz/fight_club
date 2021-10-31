import 'dart:math' as math;

class Random {
  static final _random = math.Random();

  /// Pick a random element from the given [list].
  static T element<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  /// Pick a random key from the given [map].
  static T mapElementKey<T>(Map<T, dynamic> map) {
    return map.keys.elementAt(_random.nextInt(map.keys.length));
  }

  /// Generates a random integer with the given [max] (exclusive) value
  /// and to the lowest [min] (inclusive) value if provided.
  static int integer(int max, {int min = 0}) {
    return max == min ? max : _random.nextInt(max - min) + min;
  }

  /// Generates a random boolean.
  static bool boolean() {
    return _random.nextBool();
  }

  /// Generates a random date.
  static DateTime datetime({int rangeInHours = 48}) {
    return DateTime.now().subtract(Duration(hours: integer(rangeInHours)));
  }
}
