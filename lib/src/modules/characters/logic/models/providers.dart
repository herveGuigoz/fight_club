import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Propagate current [Character] down the tree.
/// Equivalent to [InheritedWidget]
final scopedCharacter = Provider<Character>(
  (ref) => throw Exception('No Character found in context'),
);
