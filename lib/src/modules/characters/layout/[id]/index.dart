import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLayout extends ConsumerWidget {
  const CharacterLayout({
    Key? key,
    required this.caracterId,
  }) : super(key: key);

  final String caracterId;

  static Route route(String caracterId) {
    return MaterialPageRoute<void>(
      builder: (_) => CharacterLayout(caracterId: caracterId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider(caracterId));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // todo theme
        child: Column(
          children: [
            Text('Skills: ${character.skills}'),
            for (final attribute in character.attributes)
              Row(
                children: [
                  Text('$attribute'),
                  Text('cost: ${attribute.skillsPointCosts}'),
                  const Spacer(),
                  IconButton(
                    onPressed:
                        CharacterLogic.canBeIncremented(character, attribute)
                            ? () => ref
                                .read(characterProvider(caracterId).notifier)
                                .increment(attribute)
                            : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
