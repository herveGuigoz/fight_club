import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterControllerProvider =
    StateNotifierProvider.autoDispose<CharacterController, Character>(
  (ref) => CharacterController(initialState: Character()),
  name: 'characterControllerProvider',
);
