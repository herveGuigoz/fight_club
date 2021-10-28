// import 'package:fight_club/src/modules/characters/characters.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('Characters', () {
//     group('attributes', () {
//       final character = Character();
//       test('initial level is 1', () {
//         expect(character.level, equals(1));
//       });

//       test('initial skills is 12', () {
//         expect(character.skills, equals(12));
//       });

//       test('initial health is 10', () {
//         expect(character.health, equals(10));
//       });

//       test('initial attack is 0', () {
//         expect(character.attack, equals(0));
//       });

//       test('initial defense is 0', () {
//         expect(character.defense, equals(0));
//       });

//       test('initial magik is 0', () {
//         expect(character.magik, equals(0));
//       });
//     });
//     group('serialization', () {
//       const jsonString =
//           '{"level":7,"skills":0,"health":10,"attack":9,"defense":4,"magik":8}';
//       test('retrieve correct value from json', () {
//         final character = Character.fromJson(jsonString);
//         expect(character.level, equals(7));
//         expect(character.skills, equals(0));
//         expect(character.health, equals(10));
//         expect(character.attack, equals(9));
//         expect(character.defense, equals(4));
//         expect(character.magik, equals(8));
//       });

//       test('format correct json string', () {
//         final character = Character(
//           level: 7,
//           skills: 0,
//           health: 10,
//           attack: 9,
//           defense: 4,
//           magik: 8,
//         );

//         expect(character.toJson(), equals(jsonString));
//       });
//     });
//     group('equality', () {
//       test('are equals', () {
//         final characterA = Character();
//         final characterB = Character();
//         expect(characterA == characterB, isTrue);
//         expect(characterA.hashCode == characterA.hashCode, isTrue);
//       });

//       test('are not equals', () {
//         final characterA = Character(skills: 21);
//         final characterB = Character();
//         expect(characterA == characterB, isFalse);
//       });
//     });
//     group('copyWith', () {
//       test('reference current attributes', () {
//         final characterA = Character();
//         final characterB = Character().copyWith();
//         expect(characterA.level, equals(characterB.level));
//         expect(characterA.skills, equals(characterB.skills));
//         expect(characterA.health, equals(characterB.health));
//         expect(characterA.attack, equals(characterB.attack));
//         expect(characterA.defense, equals(characterB.defense));
//         expect(characterA.magik, equals(characterB.magik));
//       });
//       test('reference new attributes', () {
//         final character = Character().copyWith(
//           level: 2,
//           skills: 99,
//           health: 12,
//           attack: 1,
//           defense: 1,
//           magik: 1,
//         );
//         expect(character.level, equals(2));
//         expect(character.skills, equals(99));
//         expect(character.health, equals(12));
//         expect(character.attack, equals(1));
//         expect(character.defense, equals(1));
//         expect(character.magik, equals(1));
//       });
//     });
//   });
// }
