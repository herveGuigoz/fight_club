import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/views/layout.dart';
import 'package:flutter/material.dart';

/// Retrieve the fight details.
class FightResumeView extends StatelessWidget {
  /// Render [FightResumeLayout] inside [Scaffold] widget.
  const FightResumeView({
    Key? key,
    required this.character,
    required this.fight,
  }) : super(key: key);

  /// One of the characters who fought.
  final Character character;

  /// The fight informations.
  final Fight fight;

  /// MaterialPageRoute that will render FightResumeView
  static Route<void> route(Character character, Fight fight) {
    return MaterialPageRoute<void>(
      builder: (_) => FightResumeView(character: character, fight: fight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FightResumeLayout(character: character, fight: fight),
    );
  }
}
