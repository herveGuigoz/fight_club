import 'package:flutter_test/flutter_test.dart';
import 'package:fight_club/src/modules/characters/logic/extension.dart';

void main() {
  group('int extension to calcul skill point amount', () {
    test('3: costs 1 Skill Point to increase to 4', () {
      expect(3.skillsPointCosts(), equals(1));
    });

    test('9: costs 2 Skill Points to increase to 10', () {
      expect(9.skillsPointCosts(), equals(2));
    });

    test('32: costs 2 Skill Points to increase to 10', () {
      expect(32.skillsPointCosts(), equals(7));
    });
  });
}
