import 'dart:convert';

import 'package:fight_club/src/core/codecs/codecs.dart';
import 'package:fight_club/src/core/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterCodec', () {
    const codec = CharacterCodec();

    final character = Character(
      id: 'id',
      level: 7,
      skills: 0,
      attack: 9,
      defense: 4,
      magik: 8,
    );

    final json = {
      'id': 'id',
      'name': 'Anonymous',
      'level': 7,
      'skills': 0,
      'health': 10,
      'attack': 9,
      'defense': 4,
      'magik': 8,
    };

    test('decode correct value', () {
      final character = codec.fromMap(json);
      expect(character.id, equals('id'));
      expect(character.name, equals('Anonymous'));
      expect(character.level, equals(7));
      expect(character.skills, equals(0));
      expect(character<Health>().points, equals(10));
      expect(character<Attack>().points, equals(9));
      expect(character<Defense>().points, equals(4));
      expect(character<Magik>().points, equals(8));
      expect(character.fights, equals(<Fight>[]));
    });

    test('format correct json', () {
      expect(codec.toMap(character), equals(json));
    });
  });
  group('FightCodec', () {
    final date = DateTime.now();
    const codec = FightCodec();

    final fight = Fight(date: date);

    final json = <String, Object>{
      'date': date.millisecondsSinceEpoch,
      'rounds': <Round>[],
    };

    test('encode to string', () {
      expect(codec.encode(fight), isA<String>());
    });

    test('decode from string', () {
      expect(codec.decode(jsonEncode(json)), isA<Fight>());
    });
  });

  group('RoundCodec', () {
    const characterCodec = CharacterCodec();
    const codec = RoundCodec();
    final characterA = Character(id: 'A');
    final characterB = Character(id: 'B');
    const id = 1;
    const diceResult = 2;
    const damages = 3;

    final round = Round(
      id: id,
      diceResult: diceResult,
      damages: damages,
      attacker: characterA,
      defender: characterB,
    );

    final json = {
      'id': id,
      'diceResult': diceResult,
      'damages': damages,
      'attacker': characterCodec.toMap(characterA),
      'defender': characterCodec.toMap(characterB),
    };

    test('decode correct value', () {
      final result = codec.fromMap(json);
      expect(result.id, equals(id));
      expect(result.diceResult, equals(diceResult));
      expect(result.damages, equals(damages));
      expect(result.attacker, equals(characterA));
      expect(result.defender, equals(characterB));
    });

    test('format correct json', () {
      expect(codec.toMap(round), equals(json));
    });
  });
}
