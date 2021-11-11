import 'package:fight_club/src/core/data/models/character.dart';
import 'package:fight_club/src/modules/authentication/authentication.dart';
import 'package:fight_club/src/modules/characters/characters.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthController extends Mock implements AuthController {}

class MockCharacterController extends CharacterController {
  MockCharacterController(Character character) : super(initialState: character);

  int setNameCallCount = 0;

  @override
  void setName(String name) {
    setNameCallCount++;
    super.setName(name);
  }
}
