import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/loby/loby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fight Club')),
      body: EditCharacterLayout(
        onSave: (character) {
          ref.read(authProvider.notifier).addNewCharacter(character);
          GoRouter.of(context).go(LobbyPage.routeName);
        },
      ),
    );
  }
}
