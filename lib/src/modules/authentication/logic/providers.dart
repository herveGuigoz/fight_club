import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthController, Session>(
  (ref) => AuthController(),
  name: 'authProvider',
);

final userCharactersProvider = Provider<List<Character>>(
  (ref) => ref.watch(authProvider).characters,
  name: 'userCharactersProvider',
);

final userCharacterProvider = Provider.family.autoDispose<Character, String>(
  (ref, id) {
    final characters = ref.watch(userCharactersProvider);
    return characters.firstWhere((character) => character.id == id);
  },
  name: 'userCharacterProvider',
);

final availableCharactersProvider = Provider<Iterable<Character>>(
  (ref) {
    final characters = ref.watch(userCharactersProvider);
    return characters.where(
      (character) => !character.didLooseFightInPastHour(),
    );
  },
  name: 'availableCharactersProvider',
);

final hasCharactersProvider = Provider(
  (ref) => ref.watch(authProvider).characters.isNotEmpty,
  name: 'hasCharactersProvider',
);
