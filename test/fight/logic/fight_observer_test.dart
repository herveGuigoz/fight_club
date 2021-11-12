import 'package:fight_club/src/core/data/models/models.dart';
import 'package:fight_club/src/modules/lobby/lobby.dart';
import 'package:flutter_test/flutter_test.dart';

class MockObserver implements FightObserver {
  final calls = <Character, Fight>{};

  @override
  void didFight(Character character, Fight fight) {
    calls[character] = fight;
  }
}

void main() {
  group('fight observer', () {
    test('call didFight for both characters with multiple observers', () async {
      final observer = MockObserver();
      const attack = 20;
      const defense = 1;

      final characterA = Character(attack: attack);
      final characterB = Character(defense: defense);

      final service = FightService(observers: [observer, FightObserver()]);
      final fight = await service.launchFight(characterA, characterB);

      expect(observer.calls.length, equals(2));
      expect(observer.calls[characterA], equals(fight));
      expect(observer.calls[characterB], equals(fight));
    });
  });
}
