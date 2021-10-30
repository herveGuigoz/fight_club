import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fight Club')),
      body: const EditCharacterLayout(),
    );
  }
}
