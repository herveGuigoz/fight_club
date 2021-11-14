import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme/theme.dart';

/// Main entry point for FightClub application
class FightClub extends ConsumerWidget {
  /// Create FightClub app
  const FightClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: 'fight_club',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.dark,
      darkTheme: AppThemeData.dark,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            /// auth guard
            if (!ref.read(hasCharactersProvider)) {
              return const OnboardingView();
            }
            return const Home();
          },
        );
      },
    );
  }
}
