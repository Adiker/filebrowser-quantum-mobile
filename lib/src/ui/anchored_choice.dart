import 'package:flutter/material.dart';

/// A labelled choice whose menu position does not depend on its selected item.
class AnchoredChoice<T> extends StatelessWidget {
  const AnchoredChoice({
    super.key,
    required this.label,
    required this.value,
    required this.choices,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<T, Widget> choices;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T>(
    tooltip: label,
    position: PopupMenuPosition.under,
    onSelected: onChanged,
    itemBuilder: (context) => [
      for (final entry in choices.entries)
        PopupMenuItem<T>(
          value: entry.key,
          child: Row(
            children: [
              Expanded(child: entry.value),
              if (entry.key == value) const Icon(Icons.check, size: 18),
            ],
          ),
        ),
    ],
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      child: choices[value],
    ),
  );
}
