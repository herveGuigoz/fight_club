import 'dart:async';

import 'package:fight_club/src/core/storage/hydrated_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Specialized [StateNotifier] which handles initializing the state
/// based on the persisted state. This allows state to be persisted
/// across hot restarts as well as complete app restarts.
abstract class HydratedStateNotifier<State> extends StateNotifier<State>
    with HydratedMixin {
  HydratedStateNotifier(State state) : super(state) {
    hydrate();
  }

  /// Setter for instance of [Storage] which will be used to
  /// manage persisting/restoring the [StateNotifier] state.
  static Storage? _storage;
  static set storage(Storage? storage) => _storage = storage;

  /// Instance of [Storage] which will be used to
  /// manage persisting/restoring the [StateNotifier] state.
  static Storage get storage {
    if (_storage == null) throw const StorageNotFound();
    return _storage!;
  }
}

mixin HydratedMixin<State> on StateNotifier<State> {
  State? _state;

  /// [id] is used to uniquely identify multiple instances
  /// of the same [HydratedStateNotifier] type.
  String get id => '';

  /// `storageToken` is used as registration token for hydrated storage.
  @nonVirtual
  String get storageToken => '${runtimeType.toString()}$id';

  /// Populates the internal state storage with the latest state.
  void hydrate() {
    final storage = HydratedStateNotifier.storage;
    try {
      final stateJson = toJson(state);
      if (stateJson != null) {
        storage.write(storageToken, stateJson).then((_) {}, onError: onError);
      }
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
    }
  }

  @override
  State get state {
    final storage = HydratedStateNotifier.storage;
    if (_state != null) return _state!;
    try {
      final stateJson = storage.read(storageToken) as Map<dynamic, dynamic>?;
      if (stateJson != null) {
        _state = fromJson(stateJson.cast<String, dynamic>());
      }

      return _state ??= super.state;
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      _state = super.state;
      return super.state;
    }
  }

  @override
  set state(State value) {
    final storage = HydratedStateNotifier.storage;
    try {
      final stateJson = toJson(value);
      if (stateJson != null) {
        storage.write(storageToken, stateJson).then((_) {}, onError: onError);
      }
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
    }
    _state = value;
    super.state = value;
  }

  /// [clear] is used to wipe or invalidate the cache.
  /// Calling [clear] will delete the cached state of the state notifier
  /// but will not modify the current state of the state notifier.
  Future<void> clear() => HydratedStateNotifier.storage.delete(storageToken);

  /// Responsible for converting the `Map<String, dynamic>` representation
  /// of the state into a concrete instance of the notifier state.
  State? fromJson(Map<String, dynamic> json);

  /// Responsible for converting a concrete instance of the state
  /// into the the `Map<String, dynamic>` representation.
  ///
  /// If [toJson] returns `null`, then no state changes will be persisted.
  Map<String, dynamic>? toJson(State state);
}

/// Exception thrown if there was no [HydratedStorage] specified.
/// This is most likely due to forgetting to setup the [HydratedStorage].
class StorageNotFound implements Exception {
  const StorageNotFound();

  @override
  String toString() {
    return 'Storage was accessed before it was initialized.\n'
        'Please ensure that storage has been initialized.\n\n'
        'For example:\n\n'
        'HydratedStateNotifier.storage = await HydratedStateNotifier.build();';
  }
}
