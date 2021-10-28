import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final charactersProvider =
    StateNotifierProvider<CharactersLogic, List<Character>>((ref) {
  return CharactersLogic([Character()]);
});

final characterProvider =
    StateNotifierProvider.family<CharacterLogic, Character, String>(
  (ref, id) {
    final caracters = ref.read(charactersProvider);
    final character = caracters.firstWhere((element) => element.id == id);
    return CharacterLogic(character);
  },
);
