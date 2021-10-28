import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharactersLogic extends StateNotifier<List<Character>> {
  CharactersLogic(List<Character> state) : super(state);
}
