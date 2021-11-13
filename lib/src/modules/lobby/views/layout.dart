// ignore_for_file: lines_longer_than_80_chars

import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

class FightResumeLayout extends StatelessWidget {
  const FightResumeLayout({
    Key? key,
    required this.character,
    required this.fight,
  }) : super(key: key);

  final Character character;
  final Fight fight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final didWin = fight.didWin(character);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          didWin ? 'You win' : 'You loss',
          style: textTheme.headline6,
        ),
        const Divider(),
        for (final round in fight.rounds)
          RoundListTile(character: character, round: round)
      ],
    );
  }
}

class RoundListTile extends StatelessWidget {
  const RoundListTile({
    Key? key,
    required this.character,
    required this.round,
  }) : super(key: key);

  final Character character;
  final Round round;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final didAttack = round.attacker.id == character.id;

    return ListTile(
      tileColor: round.damages > 0
          ? didAttack
              ? AppColors.green1
              : AppColors.red7
          : null,
      dense: true,
      leading: Text(
        'Round ${round.id}:',
        style: textTheme.caption,
      ),
      title: RichText(
        text: TextSpan(
          text: '${round.diceResult} -> ',
          style: textTheme.caption,
          children: [
            TextSpan(
              text: didAttack
                  ? round.damages > 0
                      ? 'Boom! Opponent loosed ${round.damages} health points.'
                      : 'You missed your attack'
                  : round.damages > 0
                      ? 'Oouch! You loosed ${round.damages} health points.'
                      : 'Opponent missed his attack',
              style: textTheme.caption,
            ),
          ],
        ),
      ),
      trailing: Text(
        didAttack
            ? '${round.attacker<Health>().points} : ${round.defender<Health>().points}'
            : '${round.defender<Health>().points} : ${round.attacker<Health>().points}',
        style: textTheme.caption,
      ),
    );
  }
}
