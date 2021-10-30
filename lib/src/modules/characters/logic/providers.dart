import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterProvider =
    AutoDisposeStateNotifierProviderFamily<CharacterLogic, Character, String?>(
  (ref, characterId) => CharacterLogic(
    character: ref
        .read(charactersProvider)
        .firstWhere((el) => el.id == characterId, orElse: () => Character()),
  ),
);

// todo
final didUpdateAttributeProvider = Provider.autoDispose((red) {});
