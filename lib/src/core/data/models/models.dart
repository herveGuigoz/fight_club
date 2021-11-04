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
  List<T> replace(T newItem) {
    final models = <T>[];

    for (final item in this) {
      item.id == newItem.id ? models.add(newItem) : models.add(item);
    }

    return models;
  }

  List<T> delete(T newItem) {
    final models = <T>[];

    for (final item in this) {
      if (item.id == newItem.id) continue;
      models.add(item);
    }

    return models;
  }
}
