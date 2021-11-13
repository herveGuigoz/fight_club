import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/foundation.dart';

/// User's informations.
@immutable
class Session {
  /// By default user has no character.
  const Session({this.characters = const []});

  /// Characters created by user (maximum 10).
  final List<Character> characters;

  /// Clone the session with different characters.
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
