import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/lobby/logic/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'modules/settings/settings.dart';

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
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(settingsProvider),
      onGenerateRoute: ref.watch(router),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(LobbyPage.routeName);
            },
            child: const Text('Lobby'),
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
    final fightResult = ref.watch(fightResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fight result')),
      body: fightResult.when(
        data: (result) => ListView(
          children: [
            Text("Result: ${result.won ? 'win' : 'loss'}"),
            const Gap(16),
            Row(
              children: const [Text('You'), Text('opponent')],
            ),
            for (final round in result.rounds) ...[
              Text('Round: ${round.id}'),
              Row(
                children: [
                  Text('Attack: ${round.attacker.attack.points}'),
                  Text('Attack: ${round.defender.attack.points}'),
                ],
              )
            ]
          ],
        ),
        error: (error, _, __) => Center(child: Text(error.toString())),
        loading: (_) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
