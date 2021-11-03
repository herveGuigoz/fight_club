import 'package:fight_club/src/app.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fight Club', style: Theme.of(context).textTheme.headline4),
      ),
      body: EditCharacterLayout(
        onSave: (character) {
          ref.read(authProvider.notifier).addNewCharacter(character);
          Navigator.of(context).pushNamed(Home.routeName);
          // ref.read(routerProvider).go(CaractersListView.routeName);
        },
      ),
    );
  }
}
