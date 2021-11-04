import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'parsed_route.dart';
import 'route_state.dart';

/// Implementation of the RouterDelegate base class.
class TheRouterDelegate extends RouterDelegate<ParsedRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ParsedRoute> {
  TheRouterDelegate({
    required this.routeState,
    required this.builder,
    required this.navigatorKey,
  }) {
    routeState.addListener(notifyListeners);
  }
  final TheRouteState routeState;
  final WidgetBuilder builder;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => builder(context);

  @override
  Future<void> setNewRoutePath(ParsedRoute configuration) async {
    routeState.route = configuration;
    return SynchronousFuture(null);
  }

  @override
  ParsedRoute get currentConfiguration => routeState.route;

  @override
  void dispose() {
    routeState.removeListener(notifyListeners);
    routeState.dispose();
    super.dispose();
  }
}
