import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CaractersListView extends ConsumerWidget {
  const CaractersListView({Key? key}) : super(key: key);

  static const routeName = '/characters';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);

    return LobbyPage(
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(characters[index].id),
          subtitle: Text('level: ${characters[index].level}'),
          onTap: () => GoRouter.of(context).push(
            EditCharacterView.path(characters[index].id),
          ),
        ),
      ),
    );
  }
}
