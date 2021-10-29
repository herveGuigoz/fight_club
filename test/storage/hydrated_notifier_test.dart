import 'dart:async';

import 'package:fight_club/src/core/storage/storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../helpers/helpers.dart';

class MockStorage extends Mock implements Storage {}

class MyUuidHydratedLogic extends HydratedStateNotifier<String> {
  MyUuidHydratedLogic() : super(const Uuid().v4());

  @override
  Map<String, String> toJson(String state) => {'value': state};

  @override
  String? fromJson(Map<String, dynamic> json) => json['value'] as String?;
}

class MyCallbackHydratedLogic extends HydratedStateNotifier<int> {
  MyCallbackHydratedLogic({this.onFromJsonCalled}) : super(0);

  final void Function(dynamic)? onFromJsonCalled;

  void increment() => state = state + 1;

  @override
  Map<String, int> toJson(int state) => {'value': state};

  @override
  int? fromJson(dynamic json) {
    onFromJsonCalled?.call(json);
    return json['value'] as int?;
  }
}

class MyHydratedLogic extends HydratedStateNotifier<int> {
  MyHydratedLogic([
    this._id,
  ]) : super(0);

  final String? _id;

  @override
  String get id => _id ?? '';

  @override
  Map<String, int> toJson(int state) => {'value': state};

  @override
  int? fromJson(dynamic json) => json['value'] as int?;
}

class MyMultiHydratedStateNotifier extends HydratedStateNotifier<int> {
  MyMultiHydratedStateNotifier(String id)
      : _id = id,
        super(0);

  final String _id;

  @override
  String get id => _id;

  @override
  Map<String, int> toJson(int state) => {'value': state};

  @override
  int? fromJson(dynamic json) => json['value'] as int?;
}

class ErrorListener extends Mock {
  void call(Object? error, StackTrace? stackTrace);
}

class MyErrorLogic extends HydratedStateNotifier<int> {
  MyErrorLogic() : super(0);

  void increment() => state = state + 1;

  @override
  Map<String, String> toJson(int state) {
    throw Exception('_toJson_');
  }

  @override
  int? fromJson(Map<String, dynamic> json) {
    throw Exception('_fromJson_');
  }
}

void main() {
  group('HydratedLogic', () {
    late Storage storage;

    setUp(() {
      storage = setUpStorage();
    });

    test('reads from storage once upon initialization', () {
      MyCallbackHydratedLogic();
      verify<dynamic>(() => storage.read('MyCallbackHydratedLogic')).called(1);
    });

    test(
        'does not read from storage on subsequent state changes '
        'when cache value exists', () {
      when<dynamic>(() => storage.read(any())).thenReturn({'value': 42});
      final logic = MyCallbackHydratedLogic();
      expect(logic.state, 42);
      logic.increment();
      expect(logic.state, 43);
      verify<dynamic>(() => storage.read('MyCallbackHydratedLogic')).called(1);
    });

    test(
        'does not deserialize state on subsequent state changes '
        'when cache value exists', () {
      final fromJsonCalls = <dynamic>[];
      when<dynamic>(() => storage.read(any())).thenReturn({'value': 42});
      final logic = MyCallbackHydratedLogic(
        onFromJsonCalled: fromJsonCalls.add,
      );
      expect(logic.state, 42);
      logic.increment();
      expect(logic.state, 43);
      expect(fromJsonCalls, [
        {'value': 42}
      ]);
    });

    test(
        'does not read from storage on subsequent state changes '
        'when cache is empty', () {
      when<dynamic>(() => storage.read(any())).thenReturn(null);
      final logic = MyCallbackHydratedLogic();
      expect(logic.state, 0);
      logic.increment();
      expect(logic.state, 1);
      verify<dynamic>(() => storage.read('MyCallbackHydratedLogic')).called(1);
    });

    test('does not deserialize state when cache is empty', () {
      final fromJsonCalls = <dynamic>[];
      when<dynamic>(() => storage.read(any())).thenReturn(null);
      final logic = MyCallbackHydratedLogic(
        onFromJsonCalled: fromJsonCalls.add,
      );
      expect(logic.state, 0);
      logic.increment();
      expect(logic.state, 1);
      expect(fromJsonCalls, isEmpty);
    });

    test(
        'does not read from storage on subsequent state changes '
        'when cache is malformed', () {
      when<dynamic>(() => storage.read(any())).thenReturn('{');
      final logic = MyCallbackHydratedLogic();
      expect(logic.state, 0);
      logic.increment();
      expect(logic.state, 1);
      verify<dynamic>(() => storage.read('MyCallbackHydratedLogic')).called(1);
    });

    test('does not deserialize state when cache is malformed', () {
      final fromJsonCalls = <dynamic>[];
      runZonedGuarded(
        () {
          when<dynamic>(() => storage.read(any())).thenReturn('{');
          MyCallbackHydratedLogic(onFromJsonCalled: fromJsonCalls.add);
        },
        (_, __) {
          expect(fromJsonCalls, isEmpty);
        },
      );
    });

    group('SingleHydratedLogic', () {
      test('should throw StorageNotFound when storage is null', () {
        HydratedStateNotifier.storage = null;
        expect(() => MyHydratedLogic(), throwsA(isA<StorageNotFound>()));
      });

      test('StorageNotFound overrides toString', () {
        expect(
          // ignore: prefer_const_constructors
          StorageNotFound().toString(),
          'Storage was accessed before it was initialized.\n'
          'Please ensure that storage has been initialized.\n\n'
          'For example:\n\n'
          // ignore: lines_longer_than_80_chars
          'HydratedStateNotifier.storage = await HydratedStateNotifier.build();',
        );
      });

      test('storage getter returns correct storage instance', () {
        final storage = MockStorage();
        HydratedStateNotifier.storage = storage;
        expect(HydratedStateNotifier.storage, storage);
      });

      test('stores initial state when instantiated', () {
        MyHydratedLogic();
        verify(() => storage.write('MyHydratedLogic', {'value': 0})).called(1);
      });

      test('initial state should return 0 when fromJson returns null', () {
        when<dynamic>(() => storage.read(any())).thenReturn(null);
        expect(MyHydratedLogic().state, 0);
        verify<dynamic>(() => storage.read('MyHydratedLogic')).called(1);
      });

      test('initial state should return 0 when deserialization fails', () {
        when<dynamic>(() => storage.read(any())).thenThrow(Exception('oops'));
        expect(MyHydratedLogic('').state, 0);
      });

      test('initial state should return 101 when fromJson returns 101', () {
        when<dynamic>(() => storage.read(any())).thenReturn({'value': 101});
        expect(MyHydratedLogic().state, 101);
        verify<dynamic>(() => storage.read('MyHydratedLogic')).called(1);
      });

      group('clear', () {
        test('calls delete on storage', () async {
          await MyHydratedLogic().clear();
          verify(() => storage.delete('MyHydratedLogic')).called(1);
        });
      });
    });

    group('MultiHydratedStateNotifier', () {
      test('initial state should return 0 when fromJson returns null', () {
        when<dynamic>(() => storage.read(any())).thenReturn(null);
        expect(MyMultiHydratedStateNotifier('A').state, 0);
        verify<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierA'),
        ).called(1);

        expect(MyMultiHydratedStateNotifier('B').state, 0);
        verify<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierB'),
        ).called(1);
      });

      test('initial state should return 101/102 when fromJson returns 101/102',
          () {
        when<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierA'),
        ).thenReturn({'value': 101});

        expect(MyMultiHydratedStateNotifier('A').state, 101);
        verify<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierA'),
        ).called(1);

        when<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierB'),
        ).thenReturn({'value': 102});

        expect(MyMultiHydratedStateNotifier('B').state, 102);

        verify<dynamic>(
          () => storage.read('MyMultiHydratedStateNotifierB'),
        ).called(1);
      });

      group('clear', () {
        test('calls delete on storage', () async {
          await MyMultiHydratedStateNotifier('A').clear();
          verify(
            () => storage.delete('MyMultiHydratedStateNotifierA'),
          ).called(1);

          verifyNever(
            () => storage.delete('MyMultiHydratedStateNotifierB'),
          );

          await MyMultiHydratedStateNotifier('B').clear();

          verify(
            () => storage.delete('MyMultiHydratedStateNotifierB'),
          ).called(1);
        });
      });
    });

    group('MyUuidHydratedLogic', () {
      test('stores initial state when instantiated', () {
        MyUuidHydratedLogic();
        verify(
          () => storage.write('MyUuidHydratedLogic', any<dynamic>()),
        ).called(1);
      });

      test('correctly caches computed initial state', () async {
        dynamic cachedState;
        when<dynamic>(() => storage.read(any())).thenReturn(cachedState);
        when(
          () => storage.write(any(), any<dynamic>()),
        ).thenAnswer((_) => Future<void>.value());

        MyUuidHydratedLogic();
        final captured = verify(
          () => storage.write('MyUuidHydratedLogic', captureAny<dynamic>()),
        ).captured;
        cachedState = captured.first;

        when<dynamic>(() => storage.read(any())).thenReturn(cachedState);
        MyUuidHydratedLogic();
        final secondCaptured = verify(
          () => storage.write('MyUuidHydratedLogic', captureAny<dynamic>()),
        ).captured;
        final dynamic initialStateB = secondCaptured.first;

        expect(initialStateB, cachedState);
      });
    });

    group('MyErrorLogic', () {
      test('call onError', () {
        final listener = ErrorListener();
        final logic = MyErrorLogic()..onError = listener;
        logic.increment();
        verify(() => listener.call(any(), any())).called(1);
      });
    });
  });
}
