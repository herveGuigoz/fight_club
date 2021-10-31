import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/logic/characters_controller.dart';
import 'package:fight_club/src/modules/lobby/logic/fight_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final caractersProvider = Provider<CaractersController>(
  (ref) => CaractersController(),
);

/// the currently selected character for the fight
final selectedCharacterProvider = StateProvider<Character?>((ref) => null);

final fightResultProvider = FutureProvider.autoDispose((ref) async {
  final character = ref.read(selectedCharacterProvider).state;
  if (character == null) throw SelectedCharacterNotfound();

  final other = await ref.read(caractersProvider).findOpponentFor(character);

  return FightService().launchFight(character, other);
});

extension FightExtension on WidgetRef {
  void select(Character character) {
    read(selectedCharacterProvider).state = character;
  }
}

class SelectedCharacterNotfound implements Exception {
  @override
  String toString() => 'There is no character selected for the fight';
}
