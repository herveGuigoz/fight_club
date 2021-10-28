import 'package:flutter/foundation.dart';

import 'package:fight_club/src/modules/characters/logic/models/character.dart';
import 'package:fight_club/src/core/storage/storage.dart';

const kCharactersStorageKey = '_characters_';
const kCharactersLengthLimit = 10;

class AuthController extends AuthService {
  AuthController();

  void addNewCharacter(Character character) {
    if (state.characters.length >= kCharactersLengthLimit) {
      throw CharactersLengthLimitException();
    }

    state = state.copyWith(characters: [...state.characters, character]);
  }
}

/// A service that stores and retrieves auth info.
abstract class AuthService extends HydratedStateNotifier<Session> {
  AuthService({
    this.codec = const CharacterCodec(),
  }) : super(const Session());

  final CharacterCodec codec;

  @override
  Session? fromJson(Map<String, dynamic> json) {
    if (json.containsKey(kCharactersStorageKey)) {
      return Session(
        characters: codec.decodeList(json[kCharactersStorageKey] as String),
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(Session state) {
    return {
      kCharactersStorageKey: codec.encodeList(state.characters),
    };
  }
}

class Session {
  const Session({
    this.characters = const [],
  });

  final List<Character> characters;

  Session copyWith({
    List<Character>? characters,
  }) {
    return Session(
      characters: characters ?? this.characters,
    );
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

class CharactersLengthLimitException implements Exception {
  @override
  String toString() {
    return 'Maximum $kCharactersLengthLimit characters per player is allowed';
  }
}
