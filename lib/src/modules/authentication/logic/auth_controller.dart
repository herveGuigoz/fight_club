import 'dart:math';

import 'package:fight_club/src/core/codecs/session_codec.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_observer.dart';

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/core/storage/storage.dart';

const kCharactersLengthLimit = 10;

/// A class that many Widgets can interact with to read, update, or listen to
/// [Session] changes.
class AuthController extends AuthService implements FightObserver {
  AuthController();

  void addNewCharacter(Character character) {
    if (state.characters.length >= kCharactersLengthLimit) {
      throw CharactersLengthLimitException();
    }

    state = state.copyWith(characters: [...state.characters, character]);
  }

  void updateCharacter(Character character) {
    state = state.copyWith(
      characters: state.characters.replace(character),
    );
  }

  void removeCharacter(Character character) {
    state = state.copyWith(
      characters: state.characters.delete(character),
    );
  }

  @override
  void didFight(Character character, Fight fight) {
    if (!state.characters.exist(character)) return;

    final didWin = fight.didWin(character);

    updateCharacter(
      character.copyWith(
        skills: didWin ? character.skills + 1 : character.skills,
        level: didWin ? character.level + 1 : max(1, character.level - 1),
        health: kDefaultHealthPoints,
        fights: [...character.fights, fight],
      ),
    );
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
