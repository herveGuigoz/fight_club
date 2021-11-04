import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/views/character_read_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

class CharactersListView extends ConsumerWidget {
  const CharactersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(authProvider).characters;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Characters')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final character = characters[index];

                return ListTile(
                  dense: true,
                  leading: PathIcon(
                    Avatar.all
                        .firstWhere((avatar) => avatar.name == character.name)
                        .icon,
                  ),
                  title: Text(character.name),
                  trailing: Text('Level: ${character.level}'),
                  onTap: () {
                    Navigator.of(context).push(
                      CharacterReadView.route(character: character),
                    );
                  },
                );
              },
              childCount: characters.length,
            ),
          ),
        ],
      ),
    );
  }
}
