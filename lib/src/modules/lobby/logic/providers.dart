import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/logic/providers.dart';
import 'package:fight_club/src/modules/lobby/logic/characters_controller.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final caractersProvider = Provider<CaractersController>(
  (ref) => CaractersController(),
);

/// The currently selected character for the fight.
/// default value to the first character available.
final selectedCharacterProvider = StateProvider<Character?>(
  (ref) {
    final characters = ref.watch(availableCharactersProvider);
    return characters.isNotEmpty ? characters.first : null;
  },
  name: 'selectedCharacterProvider',
);

final fightService = Provider(
  (ref) => FightService(
    observers: [ref.read(authProvider.notifier)],
  ),
  name: 'fightService',
);

final fightResultProvider = FutureProvider.autoDispose(
  (ref) async {
    final character = ref.read(selectedCharacterProvider);
    if (character == null) throw SelectedCharacterNotfound();

    final other = await ref.read(caractersProvider).findOpponentFor(character);

    final fight = await ref.read(fightService).launchFight(character, other);

    return FightResult(
      character: character,
      opponent: other,
      didWin: fight.didWin(character),
      fight: fight,
    );
  },
  name: 'fightResultProvider',
);

extension FightExtension on WidgetRef {
  void select(Character character) {
    final controller = read(selectedCharacterProvider.state);
    controller.state = character;
  }
}

class SelectedCharacterNotfound implements Exception {
  @override
  String toString() => 'There is no character selected for the fight';
}