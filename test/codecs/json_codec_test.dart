import 'package:fight_club/src/core/codecs/json_codec.dart';
import 'package:flutter_test/flutter_test.dart';

class Human {
  Human(this.name);
  final String name;
}

class HumanCodec extends JsonCodec<Human> {
  @override
  Human fromMap(Map<String, dynamic> json) => Human(json['name'] as String);

  @override
  Map<String, dynamic> toMap(Human value) => {'name': value.name};
}

void main() {
  group('JsonCodec', () {
    final codec = HumanCodec();
    final value = Human('jhondoe');
    const json = '{"name":"jhondoe"}';

    test('encode to string', () {
      expect(codec.encode(value), json);
    });

    test('decode from string', () {
      expect(codec.decode(json), isA<Human>());
    });
  });
}
