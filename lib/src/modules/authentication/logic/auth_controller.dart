import 'package:fight_club/src/core/codecs/session_codec.dart';
import 'package:flutter/foundation.dart';

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/storage/storage.dart';

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
    state = state.copyWith(
      characters: state.characters.replace(character).toList(),
    );
  }

  void removeCharacter(Character character) {
    assertCharacterExistInState(character);
    state = state.copyWith(
      characters: state.characters.delete(character).toList(),
    );
  }

  @visibleForTesting
  void assertCharacterExistInState(Character character) {
    if (!state.characters.any((element) => element.id == character.id)) {
      throw CharacterNotFoundException(character);
    }
  }
}

/// A service that stores and retrieves auth info.
abstract class AuthService extends HydratedStateNotifier<Session> {
  AuthService() : super(const Session());

  static const codec = SessionCodec();

  @override
  void hydrate() {/* do not persist the initial state to storage on start */}

  /// Loads [Session] from local storage.
  @override
  Session? fromJson(Map<String, dynamic> json) => codec.fromMap(json);

  /// Persists [Session] to local storage.
  @override
  Map<String, dynamic>? toJson(Session state) => codec.toMap(state);
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
