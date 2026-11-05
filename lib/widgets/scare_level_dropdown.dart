import 'package:flutter/material.dart';

class ScareLevelDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String> onChanged; // Tells the screen which level was picked

  const ScareLevelDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      
      initialSelection: selectedValue,
      // Replaces 'isExpanded: true' to stretch across the full width
      expandedInsets: EdgeInsets.zero,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      
      textStyle: TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant, // Default theme color in Light Mode
      ),
      
      // Maps your array to the modern Material 3 entry objects
      dropdownMenuEntries: items.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
      
      // Triggers when a new selection is chosen
       onSelected: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}