import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_icon/path_icon.dart';
import 'package:theme/theme.dart';

import 'modules/characters/characters.dart';

typedef Router = Route<dynamic>? Function(RouteSettings);

final router = Provider<Router>((ref) {
  return (settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) {
        /// auth guard
        if (!ref.read(hasCharactersProvider)) return const OnboardingView();

        final location = settings.name;

        switch (location) {
          case FightResultView.routeName:
            return const FightResultView();
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
      restorationScopeId: 'fight_club',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('en', '')],
      theme: AppThemeData.dark,
      darkTheme: AppThemeData.dark,
      onGenerateRoute: ref.watch(router),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  static final destinations = <Destination>[
    Destination(
      label: 'Characters',
      icon: PathIcon(PathIcons.users),
      child: const CharactersListView(),
    ),
    Destination(
      label: 'Lobby',
      icon: PathIcon(PathIcons.battle),
      child: const LobbyView(),
    ),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canCreateCharacter = ref.watch(isCharacterCreationAllowedProvider);

    return Scaffold(
      floatingActionButton: selectedIndex == 0 && canCreateCharacter
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.of(context).push(CreateCharacterView.route());
              },
              child: PathIcon(PathIcons.add),
            )
          : null,
      body: IndexedStack(
        index: selectedIndex,
        children: destinations.map((destination) => destination.child).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        selectedLabelStyle: theme.textTheme.caption,
        unselectedLabelStyle: theme.textTheme.caption,
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index != selectedIndex) {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        items: destinations
            .map((destination) => BottomNavigationBarItem(
                  icon: destination.icon,
                  label: destination.label,
                ))
            .toList(),
      ),
    );
  }
}

class Destination {
  const Destination({
    required this.label,
    required this.icon,
    required this.child,
  });

  final String label;
  final Widget icon;
  final Widget child;
}
