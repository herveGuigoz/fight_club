import 'package:flutter/foundation.dart';

import 'package:fight_club/src/core/data/models/models.dart';

/// Auth informations
class Session {
  const Session({this.characters = const []});

  final List<Character> characters;

  Session copyWith({List<Character>? characters}) {
    return Session(characters: characters ?? this.characters);
  }

  @override
  String toString() => 'Session(characters: $characters)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Session && listEquals(other.characters, characters);
  }

  @override
  int get hashCode => characters.hashCode;
}
