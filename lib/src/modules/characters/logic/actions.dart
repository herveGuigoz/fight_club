import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CharacterActions on WidgetRef {
  void downgrade(Attribute attribute, {Character? character}) {
    read(characterProvider(character?.id).notifier).downgrade(attribute);
  }

  void upgrade(Attribute attribute, {String? caracterId}) {
    read(characterProvider(caracterId).notifier).upgrade(attribute);
  }
}
