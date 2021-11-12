import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/logic/providers.dart';
import 'package:fight_club/src/modules/lobby/logic/characters_controller.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for random characters.
final charactersProvider = Provider<CharactersController>((ref) {
  return CharactersController();
});

/// User's character selected for the fight.
/// Default value to the first character available.
final selectedCharacterProvider = StateProvider<Character?>((ref) {
  final characters = ref.watch(availableCharactersProvider);
  return characters.isNotEmpty ? characters.first : null;
});

/// Service to compute fight result.
final fightService = Provider((ref) {
  return FightService(
    observers: [
      ref.watch(authProvider.notifier),
      ref.watch(charactersProvider),
    ],
  );
});

/// Find opponent from [CharactersController] and run the fight.
final fightResultProvider = FutureProvider.autoDispose((ref) async {
  final character = ref.read(selectedCharacterProvider);
  if (character == null) throw SelectedCharacterNotfound();

  final other = await ref.read(charactersProvider).findOpponentFor(character);

  final fight = await ref.read(fightService).launchFight(character, other);

  return FightResult(
    character: character,
    opponent: other,
    didWin: fight.didWin(character),
    fight: fight,
  );
});

/// Error thrown when trying to launch a fight without previously add
/// character to [selectedCharacterProvider].
class SelectedCharacterNotfound implements Exception {
  @override
  String toString() => 'There is no character selected for the fight';
}
