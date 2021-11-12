import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for current session. Store and update user's characters.
final authProvider = StateNotifierProvider<AuthController, Session>((ref) {
  return AuthController();
});

/// User's characters list.
final userCharactersProvider = Provider<List<Character>>((ref) {
  return ref.watch(authProvider).characters;
});

/// User's characters who did not loose a fight within past hour.
final availableCharactersProvider = Provider<Iterable<Character>>((ref) {
  final characters = ref.watch(userCharactersProvider);
  return characters.where(
    (character) => !character.didLooseFightInPastHour(),
  );
});

/// Wrapper to listen if user is authenticated aka he has already created
/// at least one character.
final hasCharactersProvider = Provider((ref) {
  return ref.watch(authProvider).characters.isNotEmpty;
});

/// Watch user's characters count and notify when list is full.
final isCharacterCreationAllowedProvider = Provider((ref) {
  return ref.watch(userCharactersProvider).length < kCharactersLengthLimit;
});
