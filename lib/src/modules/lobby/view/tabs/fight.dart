import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class FightView extends StatelessWidget {
  const FightView({Key? key}) : super(key: key);

  static const routeName = '/fight';

  @override
  Widget build(BuildContext context) {
    return LobbyPage(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Choose your character:'),
            Gap(16),
            // DropdownButton(items: items),
            Text(
              'Only characters that have not loosed a fight in the past hour '
              'will be in the list.',
            ),
          ],
        ),
      ),
    );
  }
}
