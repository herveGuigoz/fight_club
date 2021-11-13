import 'package:fight_club/src/modules/authentication/logic/providers.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

/// Main view for authenticated user.
class Home extends ConsumerStatefulWidget {
  /// Render bottom bar to navigate between user's characters list and lobby.
  const Home({Key? key}) : super(key: key);

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
            .map(
              (destination) => BottomNavigationBarItem(
                icon: destination.icon,
                label: destination.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Value object to build bottom nvigation bar icons.
class Destination {
  /// Unique constructor where all fields are required.
  const Destination({
    required this.label,
    required this.icon,
    required this.child,
  });

  /// The text label of the destination.
  final String label;

  /// The icon of the destination.
  final Widget icon;

  /// The content to render when the destination is selected.
  final Widget child;
}
