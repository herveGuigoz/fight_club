import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';

class Destination {
  const Destination(this.label, this.path, this.icon);

  final String label;
  final String path;
  final Widget icon;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Destination &&
        other.label == label &&
        other.path == path &&
        other.icon == icon;
  }

  @override
  int get hashCode => label.hashCode ^ path.hashCode ^ icon.hashCode;
}

class LobbyPage extends StatefulWidget {
  const LobbyPage({
    Key? key,
    required this.body,
  }) : super(key: key);

  final Widget body;

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  static const destinations = <Destination>[
    Destination(
      'characters',
      CaractersListView.routeName,
      Icon(Icons.call),
    ),
    Destination(
      'fight',
      FightView.routeName,
      Icon(Icons.call),
    ),
  ];

  bool isDestinationSelected(Destination destination, String currentPath) {
    return pathToRegExp(currentPath, prefix: true).hasMatch(destination.path);
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(context).location;
    final currentIndex = destinations.indexWhere(
      (destination) => isDestinationSelected(destination, currentPath),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(destinations[currentIndex].label),
        centerTitle: true,
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        iconSize: 20,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: currentIndex,
        items: [
          for (final destination in destinations)
            BottomNavigationBarItem(
              icon: destination.icon,
              label: destination.label,
            )
        ],
        onTap: (index) {
          GoRouter.of(context).go(destinations[index].path);
        },
      ),
    );
  }
}
