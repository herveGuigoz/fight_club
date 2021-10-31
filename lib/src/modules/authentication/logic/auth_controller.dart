import 'package:flutter/foundation.dart';

import 'package:fight_club/src/modules/characters/logic/models/character.dart';
import 'package:fight_club/src/core/storage/storage.dart';

const kCharactersStorageKey = '_characters_';
const kCharactersLengthLimit = 10;

/// A class that many Widgets can interact with to read, update, or listen to
/// [Session] changes.
class AuthController extends AuthService {
  AuthController();

  void addNewCharacter(Character character) {
    if (state.characters.length >= kCharactersLengthLimit) {
      throw CharactersLengthLimitException();
    }

    state = state.copyWith(characters: [...state.characters, character]);
  }

  void updateCharacter(Character character) {
    assertCharacterExistInState(character);
    state = state.copyWith(characters: state.characters.replace(character));
  }

  void removeCharacter(Character character) {
    assertCharacterExistInState(character);
    state = state.copyWith(characters: state.characters.delete(character));
  }

  @protected
  @visibleForTesting
  void assertCharacterExistInState(Character character) {
    if (!state.characters.any((element) => element.id == character.id)) {
      throw CharacterNotFoundException(character);
    }
  }
}

/// A service that stores and retrieves auth info.
abstract class AuthService extends HydratedStateNotifier<Session> {
  AuthService({
    this.codec = const CharacterCodec(),
  }) : super(const Session());

  // Session's encoder/decoder
  final CharacterCodec codec;

  @override
  void hydrate() {/* do not persist the initial state to storage on start */}

  /// Loads [Session] from local storage.
  @override
  Session? fromJson(Map<String, dynamic> json) {
    if (json.containsKey(kCharactersStorageKey)) {
      return Session(
        characters: codec.decodeList(json[kCharactersStorageKey] as String),
      );
    }
  }

  /// Persists [Session] to local storage.
  @override
  Map<String, dynamic>? toJson(Session state) {
    return {
      kCharactersStorageKey: codec.encodeList(state.characters),
    };
  }
}

/// Auth informations
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

class CharacterNotFoundException implements Exception {
  CharacterNotFoundException(this.character);

  final Character character;

  @override
  String toString() {
    return 'Could not find any character with id ${character.id}';
  }
}

/// Utilities to interact with [List] of [Model]
extension ListExtension<T extends Model> on List<T> {
  bool matchId(T oldItem, T newItem) => oldItem.id == newItem.id;

  List<T> replace(T newItem) {
    return map((oldItem) => matchId(oldItem, newItem) ? oldItem : newItem)
        .toList();
  }

  List<T> delete(T newItem) {
    return where((oldItem) => !matchId(oldItem, newItem)).toList();
  }
}
