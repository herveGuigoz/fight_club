import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CaractersListView(),
      bottomNavigationBar: BottomNavigationBar(
        mouseCursor: SystemMouseCursors.grab,
        iconSize: 20,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}

class CaractersListView extends ConsumerWidget {
  const CaractersListView({Key? key}) : super(key: key);

  static const routeName = '/characters';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);

    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(characters[index].id),
        onTap: () {},
      ),
    );
  }
}
