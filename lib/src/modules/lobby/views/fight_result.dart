import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:fight_club/src/modules/lobby/views/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Process fight and show repport.
class FightResultView extends ConsumerWidget {
  /// Render CircularProgressIndicator during fight processing and then either
  /// the failure reason or FightResumeLayout on success.
  const FightResultView({Key? key}) : super(key: key);

  /// MaterialPageRoute that will render FightResultView
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const FightResultView());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fightResult = ref.watch(fightResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fight result')),
      body: fightResult.when(
        data: (result) => FightResumeLayout(
          character: result.character,
          fight: result.fight,
        ),
        error: (error, _) => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
