import 'package:flutter/material.dart';

/// The default not found page.
class DefaultNotFoundPage extends StatelessWidget {
  /// Initializes the page with the path that couldn't be found.
  const DefaultNotFoundPage({Key? key, required this.path}) : super(key: key);

  /// The path that couldn't be found.
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Page '$path' wasn't found."),
        ),
      ),
    );
  }
}
