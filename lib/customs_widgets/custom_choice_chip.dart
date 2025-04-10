
import 'package:agri_flutter/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customChoiceChip({
  required String label,
  required String selectedCategory,
  required Function(String) onSelected,
 required BuildContext context  ,

}) {
  return ChoiceChip(
    label: Text(label),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
    selected: selectedCategory == label,
    selectedColor: themeColor(context: context).secondaryContainer,
    onSelected: (bool value) {
      onSelected(value ? label : '');
    },
  );
}
