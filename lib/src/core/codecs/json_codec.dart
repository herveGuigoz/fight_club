import 'dart:convert';

/// Provide processes for translating a data structure into a format that can be
/// stored or transmitted.
abstract class JsonCodec<T> {
  /// {@nodoc}
  const JsonCodec();

  /// Convert data structure into a collection of key/value pairs.
  Map<String, dynamic> toMap(T value);

  /// Create data structure from a collection of key/value pairs.
  T fromMap(Map<String, dynamic> json);

  /// Convert data structure into Json string format.
  String encode(T value) {
    return jsonEncode(toMap(value));
  }

  /// Create data structure from Json string.
  T decode(String json) {
    return fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Convert list of data structures into Json string format.
  String encodeList(List<T> value) {
    return jsonEncode(value.map(toMap).toList());
  }

  /// Create list of data structure from Json string.
  List<T> decodeList(String value) {
    return (jsonDecode(value) as List<dynamic>)
        .map((dynamic x) => fromMap(x as Map<String, dynamic>))
        .toList()
        .cast<T>();
  }
}
