import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/lobby/logic/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:path_icon/path_icon.dart';
import 'package:theme/theme.dart';

typedef Router = Route<dynamic>? Function(RouteSettings);

final router = Provider<Router>((ref) {
  return (settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        /// auth guard
        if (!ref.read(hasCharactersProvider)) return const OnboardingPage();

        final location = settings.name;

        switch (location) {
          case LobbyPage.routeName:
            return const LobbyPage();
          case FightResultPage.routeName:
            return const FightResultPage();
          default:
            return const Home();
        }
      },
    );
  };
});

class FightClub extends ConsumerWidget {
  const FightClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en', '')],
      // theme: ThemeData(),
      // darkTheme: ThemeData.dark(),
      // themeMode: ref.watch(settingsProvider),
      theme: AppThemeData.dark,
      darkTheme: AppThemeData.dark,
      onGenerateRoute: ref.watch(router),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {},
        child: PathIcon(PathIcons.add),
      ),
      appBar: AppBar(title: const Text('Characters')),
      body: Wrap(
        runSpacing: 8,
        children: <PathIconData>[
          PathIcons.anonymous,
          PathIcons.bender,
          PathIcons.brutus,
          PathIcons.buzzLightyear,
          PathIcons.frankensteins,
          PathIcons.homer,
          PathIcons.ninja,
          PathIcons.stormtrooper,
          PathIcons.walterWhite,
          PathIcons.yoda,
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PathIcon(e, size: 80),
                ))
            .toList(),
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     OutlinedButton(
      //       onPressed: () {
      //         Navigator.of(context).pushNamed(LobbyPage.routeName);
      //       },
      //       child: const Text('Lobby'),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        selectedLabelStyle: theme.textTheme.caption,
        unselectedLabelStyle: theme.textTheme.caption,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: PathIcon(PathIcons.users),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: PathIcon(PathIcons.battle),
            label: 'Fights',
          ),
        ],
      ),
    );
  }
}

class LobbyPage extends ConsumerWidget {
  const LobbyPage({Key? key}) : super(key: key);

  static const routeName = '/lobby';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);
    final selectedCharacter = ref.watch(selectedCharacterProvider).state;

    return Scaffold(
      appBar: AppBar(title: const Text('Lobby')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text('Choose your character:'),
            const Gap(16),
            DropdownButton<Character>(
              value: selectedCharacter,
              onChanged: (character) => ref.select(character!),
              items: [
                for (final character in characters)
                  DropdownMenuItem(
                    value: character,
                    child: Text(character.id),
                  )
              ],
            ),
            const Gap(16),
            const Text(
              'Only characters that have not loosed a fight in the past hour '
              'will be in the list.',
            ),
            const Spacer(),
            Center(
              child: OutlinedButton(
                onPressed: selectedCharacter != null
                    ? () => Navigator.of(context).pushNamed(
                          FightResultPage.routeName,
                        )
                    : null,
                child: const Text('Fight'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class FightResultPage extends ConsumerWidget {
  const FightResultPage({Key? key}) : super(key: key);

  static const routeName = 'result';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final fightResult = ref.watch(fightResultProvider);

    return Scaffold(
      // todo: 'you loose/win!' on AppBar
      appBar: AppBar(title: const Text('Fight result')),
      body: fightResult.when(
        data: (result) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Result: ${result.won ? 'You win' : 'You loss'}",
              style: textTheme.headline6,
            ),
            const Divider(),
            for (final round in result.rounds)
              ListTile(
                tileColor: round.damages > 0
                    ? round.id.isOdd
                        ? Colors.green[300]
                        : Colors.red[300]
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
                        text: round.id.isOdd
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
                  round.id.isOdd
                      ? '${round.attacker.health.points} : ${round.defender.health.points}'
                      : '${round.defender.health.points} : ${round.attacker.health.points}',
                  style: textTheme.caption,
                ),
              )
          ],
        ),
        error: (error, _, __) => Center(
          child: Text(error.toString()),
        ),
        loading: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
