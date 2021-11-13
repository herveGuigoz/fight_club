/// Imutable data class
abstract class Model {
  /// Allow implementations to be constants for performance boost as once an
  /// model is built, in the lifetime of the app, it will remain the same.
  const Model(this.id);

  /// Unique identifier for this object.
  final String id;
}

/// Utilities to interact with Iterable of [Model]
extension IterableExtension<T extends Model> on Iterable<T> {
  /// Checks whether any element of this list match [Model]'s id.
  bool exist(Model value) {
    return any((character) => character.id == value.id);
  }

  /// Update elements with [newItem] on this list where the ids match.
  List<T> replace(T newItem) {
    final models = <T>[];

    for (final item in this) {
      item.id == newItem.id ? models.add(newItem) : models.add(item);
    }

    return models;
  }

  /// Remove elements on this list where the ids match.
  List<T> delete(T model) {
    final models = <T>[];

    for (final item in this) {
      if (item.id == model.id) continue;
      models.add(item);
    }

    return models;
  }
}
