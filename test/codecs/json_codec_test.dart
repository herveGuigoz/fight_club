import 'package:flutter_test/flutter_test.dart';

import 'package:fight_club/src/core/codecs/json_codec.dart';

class Human {
  Human(this.name);
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Human && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
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

    test('encodeList', () {
      const json = r'[{"name":"A"},{"name":"B"}]';
      expect(codec.encodeList([Human('A'), Human('B')]), equals(json));
    });

    test('decodeList', () {
      const json = r'[{"name":"A"},{"name":"B"}]';
      expect(codec.decodeList(json), equals([Human('A'), Human('B')]));
    });
  });
}
