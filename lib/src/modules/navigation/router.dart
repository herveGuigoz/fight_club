import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:fight_club/src/modules/navigation/pages.dart';
import 'package:fight_club/src/modules/navigation/transition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: OnboardingView.routeName,
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: const OnboardingView(),
        ),
      ),
      GoRoute(
        path: EditCharacterView.routeName,
        redirect: (state) {
          if (state.params['id'] == null) return OnboardingView.routeName;
        },
        pageBuilder: (context, state) => FadeTransitionPage<void>(
          key: state.pageKey,
          child: EditCharacterView(caracterId: state.params['id']!),
        ),
      )
    ],
    redirect: (state) {
      final goingToOnboarding = state.location == OnboardingView.routeName;
      if (!goingToOnboarding && !ref.read(hasCharactersProvider)) {
        return OnboardingView.routeName;
      }
    },
    errorPageBuilder: (context, state) => FadeTransitionPage<void>(
      child: DefaultNotFoundPage(path: state.location),
    ),
  );
});
