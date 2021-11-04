import 'package:fight_club/src/app.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({Key? key}) : super(key: key);

  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your avatar'),
      ),
      body: EditCharacterLayout(
        onSave: (character) {
          ref.read(authProvider.notifier).addNewCharacter(character);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(Home.routeName);
          });
        },
      ),
    );
  }
}
