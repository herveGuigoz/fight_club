import 'package:fight_club/src/modules/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modules/settings/settings.dart';

class FightClub extends ConsumerWidget {
  const FightClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    return MaterialApp.router(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(settingsProvider),
      // onGenerateRoute: (RouteSettings routeSettings) {
      //   return MaterialPageRoute<void>(
      //     settings: routeSettings,
      //     builder: (BuildContext context) {
      //       final location = routeSettings.name;
      //       final params = routeSettings.arguments;

      //       final goingToOnboarding = location == OnboardingPage.routeName;
      //       if (!goingToOnboarding && !ref.read(hasCharactersProvider)) {
      //         return const OnboardingPage();
      //       }

      //       switch (location) {
      //         case OnboardingPage.routeName:
      //           return const OnboardingPage();
      //         case LobbyPage.routeName:
      //         default:
      //           return const LobbyPage();
      //       }
      //     },
      //   );
      // },
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
