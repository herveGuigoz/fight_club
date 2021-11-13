import 'dart:convert';

abstract class JsonCodec<T> {
  const JsonCodec();

  Map<String, dynamic> toMap(T value);

  T fromMap(Map<String, dynamic> json);

  String encode(T value) {
    return jsonEncode(toMap(value));
  }

  T decode(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  String encodeList(List<T> value) {
    return jsonEncode(value.map(toMap).toList());
  }

  List<T> decodeList(String value) {
    return (jsonDecode(value) as List<dynamic>)
        .map((dynamic x) => fromMap(x as Map<String, dynamic>))
        .toList()
        .cast<T>();
  }
}
