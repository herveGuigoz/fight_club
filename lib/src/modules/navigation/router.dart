import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:fight_club/src/modules/navigation/pages.dart';
import 'package:fight_club/src/modules/navigation/transition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: OnboardingPage.routeName,
    routes: [
      GoRoute(
        path: OnboardingPage.routeName,
        redirect: (state) {
          if (ref.read(hasCharactersProvider)) {
            return CaractersListView.routeName;
          }
        },
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: CaractersListView.routeName,
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: const CaractersListView(),
        ),
      ),
      GoRoute(
        path: FightView.routeName,
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: const FightView(),
        ),
      ),
      GoRoute(
        path: CreateCharacterView.routeName,
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: const CreateCharacterView(),
        ),
      ),
      GoRoute(
        path: EditCharacterView.routeName,
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: EditCharacterView(caracterId: state.params['id']!),
        ),
      )
    ],
    errorPageBuilder: (context, state) => FadeTransitionPage<void>(
      child: DefaultNotFoundPage(path: state.location),
    ),
  );
});
