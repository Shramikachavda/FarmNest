
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';

Widget customChoiceChip({
  required String label,
  required String selectedCategory,
  required Function(String) onSelected,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ChoiceChip(
      label: Text(label),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      selected: selectedCategory == label,
      selectedColor: themeColor().primary,
      disabledColor: Colors.grey,
      onSelected: (bool value) {
        onSelected(value ? label : '');
      },
    ),
  );
}
