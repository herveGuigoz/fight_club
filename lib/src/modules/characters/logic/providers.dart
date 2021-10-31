import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterProvider = AutoDisposeStateNotifierProviderFamily<
    CharacterController, CharacterChanges, String?>(
  (ref, characterId) => CharacterController(
    character: ref
        .read(charactersProvider)
        .firstWhere((el) => el.id == characterId, orElse: () => Character()),
  ),
);
