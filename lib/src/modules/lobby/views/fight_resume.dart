import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/views/layout.dart';
import 'package:flutter/material.dart';

class FightResumeView extends StatelessWidget {
  const FightResumeView({
    Key? key,
    required this.character,
    required this.fight,
  }) : super(key: key);

  final Character character;
  final Fight fight;

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
