import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// todo: use currentCharacterProvider
final characterProvider = AutoDisposeStateNotifierProviderFamily<
    CharacterController, CharacterChanges, String?>(
  (ref, characterId) => CharacterController(
    character: ref
        .read(charactersProvider)
        .firstWhere((el) => el.id == characterId, orElse: () => Character()),
  ),
);

/// the currently selected character
final currentCharacterProvider = StateProvider((ref) => Character());
