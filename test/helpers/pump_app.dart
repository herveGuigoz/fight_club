import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    List<ProviderObserver>? observers,
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        observers: observers,
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
  }
}
