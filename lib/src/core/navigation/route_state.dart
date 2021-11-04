import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'parsed_route.dart';
import 'parser.dart';

/// The current route state. To change the current route, call obtain the state
/// using `RouteStateScope.of(context)` and call `go()`:
///
/// ```
/// Router.of(context).go('/characters/2');
/// ```
class TheRouteState extends ChangeNotifier {
  TheRouteState(this._parser) : _route = _parser.initialRoute;

  final TheRouteParser _parser;

  ParsedRoute _route;
  ParsedRoute get route => _route;
  set route(ParsedRoute route) {
    // Don't notify listeners if the path hasn't changed.
    if (_route == route) return;

    _route = route;
    notifyListeners();
  }

  Future<void> go(String route) async {
    this.route = await _parser.parseRouteInformation(
      RouteInformation(location: route),
    );
  }
}

/// Provides the current [TheRouteState] to descendant widgets in the tree.
class Router extends InheritedNotifier<TheRouteState> {
  const Router({
    required TheRouteState notifier,
    required Widget child,
    Key? key,
  }) : super(key: key, notifier: notifier, child: child);

  static TheRouteState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Router>()!.notifier!;
  }
}
