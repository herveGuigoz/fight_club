import 'package:flutter/material.dart';

/// {@template OutlinedListTile}
/// A single row for rendering attribute's name and value.
/// {@endtemplate}
class OutlinedListTile extends StatelessWidget {
  /// {@macro OutlinedListTile}
  const OutlinedListTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  /// Attribute name
  final String label;

  /// Attribute value
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      constraints: const BoxConstraints(minHeight: 60),
      child: Row(
        children: [
          Text(label),
          Expanded(child: Center(child: Text('$value'))),
        ],
      ),
    );
  }
}
