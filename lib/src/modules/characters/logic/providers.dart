import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

/// Controller to edit attributes.
final characterControllerProvider =
    StateNotifierProvider.autoDispose<CharacterController, Character>(
  (ref) => CharacterController(initialState: Character()),
);

/// Avalaible avatars within [Avatar.all] list.
final avatarsProvider = Provider((ref) {
  final avatars = Avatar.all;
  final characters = ref.watch(userCharactersProvider);
  final names = characters.map((character) => character.name);

  return avatars.where((avatar) => !names.contains(avatar.name)).toList();
});
