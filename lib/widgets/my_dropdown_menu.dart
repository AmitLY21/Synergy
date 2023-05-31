import 'package:flutter/material.dart';

class MyDropdownMenu extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String?> onChanged;
  final List<String> values;

  MyDropdownMenu({
    required this.selectedCategory,
    required this.onChanged,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        onChanged: onChanged,
        items: values.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        hint: const Text('Select Category'),
      ),
    );
  }
}
