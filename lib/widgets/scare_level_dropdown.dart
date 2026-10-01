import 'package:flutter/material.dart';

class ScareLevelDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> items;

  const ScareLevelDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      isExpanded: true,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }
}