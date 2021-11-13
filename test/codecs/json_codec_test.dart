import 'package:fight_club/src/core/codecs/json_codec.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@immutable
class Human {
  const Human(this.name);
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
  Human fromMap(Map<String, dynamic> json) {
    return Human(json['name'] as String);
  }

  @override
  Map<String, dynamic> toMap(Human value) {
    return <String, String>{'name': value.name};
  }
}

void main() {
  group('JsonCodec', () {
    final codec = HumanCodec();
    const value = Human('jhondoe');
    const json = '{"name":"jhondoe"}';

    test('encode to string', () {
      expect(codec.encode(value), json);
    });

    test('decode from string', () {
      expect(codec.decode(json), isA<Human>());
    });

    test('encodeList', () {
      const json = '[{"name":"A"},{"name":"B"}]';
      expect(codec.encodeList(const [Human('A'), Human('B')]), equals(json));
    });

    test('decodeList', () {
      const json = '[{"name":"A"},{"name":"B"}]';
      expect(codec.decodeList(json), equals(const [Human('A'), Human('B')]));
    });
  });
}
