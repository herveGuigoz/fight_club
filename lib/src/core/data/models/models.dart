export 'attribute.dart';
export 'character.dart';
export 'fight.dart';
export 'round.dart';
export 'session.dart';

/// Imutable data class
abstract class Model {
  const Model(this.id);

  final String id;
}

/// Utilities to interact with Iterable of [Model]
extension IterableExtension<T extends Model> on Iterable<T> {
  bool matchId(T oldItem, T newItem) => oldItem.id == newItem.id;

  Iterable<T> replace(T newItem) {
    return map((oldItem) => matchId(oldItem, newItem) ? oldItem : newItem);
  }

  Iterable<T> delete(T newItem) {
    return where((oldItem) => !matchId(oldItem, newItem));
  }
}
