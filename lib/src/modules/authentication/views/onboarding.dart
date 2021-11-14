import 'package:fight_club/src/core/data/models/character.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// View for unauthenticated user.
class OnboardingView extends ConsumerWidget {
  /// Render [CharacterLayout] inside [Scaffold] widget to create the first
  /// character.
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your avatar'),
      ),
      body: SingleChildScrollView(
        child: CharacterLayout(
          mode: Mode.create,
          character: Character(),
          onSave: (character) {
            ref.read(authProvider.notifier).addNewCharacter(character);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (_) => const Home()),
            );
          },
        ),
      ),
    );
  }
}
