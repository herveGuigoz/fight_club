import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthController, Session>((ref) {
  return AuthController();
});

final charactersProvider = Provider<List<Character>>((ref) {
  return ref.watch(authProvider).characters;
});

final hasCharactersProvider = Provider(
  (ref) => ref.watch(authProvider).characters.isNotEmpty,
);
