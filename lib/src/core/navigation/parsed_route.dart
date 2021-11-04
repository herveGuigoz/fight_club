import 'parser.dart';

/// A route path that has been parsed by [TheRouteParser].
class ParsedRoute {
  ParsedRoute(
    this.path,
    this.pathTemplate,
    this.parameters,
    this.queryParameters,
  );

  /// The current path location without query parameters. (/book/123)
  final String path;

  /// The path template (/book/:id)
  final String pathTemplate;

  /// The path parameters ({id: 123})
  final Map<String, String> parameters;

  /// The query parameters ({search: abc})
  final Map<String, String> queryParameters;

  @override
  String toString() => '<ParsedRoute '
      'template: $pathTemplate '
      'path: $path '
      'parameters: $parameters '
      'query parameters: $queryParameters>';
}
