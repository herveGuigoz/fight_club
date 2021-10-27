import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings/settings_controller.dart';

class FightClub extends ConsumerWidget {
  const FightClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      restorationScopeId: 'app',
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
      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      // onGenerateRoute: (RouteSettings routeSettings) {
      //   return MaterialPageRoute<void>(
      //     settings: routeSettings,
      //     builder: (BuildContext context) {
      //       return Container();
      //       switch (routeSettings.name) {
      //         case SettingsView.routeName:
      //           return SettingsView(controller: settingsController);
      //         case SampleItemDetailsView.routeName:
      //           return const SampleItemDetailsView();
      //         case SampleItemListView.routeName:
      //         default:
      //           return const SampleItemListView();
      //       }
      //     },
      //   );
      // },
      home: Container(),
    );
  }
}
