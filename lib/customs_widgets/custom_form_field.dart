import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    this.icon, // Now supports any widget (Icon, IconButton, etc.)
    required this.hintText,
    required this.keyboardType,
    required this.label,
    required this.textEditingController,
    this.obscureText = false,
    this.isPasswordField = false, // ✅ New flag for password fields
    this.validator,
    this.isDatePicker = false, // ✅ Flag for date picker
    this.onTogglePassword, // ✅ New function for toggling password visibility
    super.key,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final Widget? icon; // ✅ Accepts both `Icon` and `IconButton`
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isDatePicker;
  final bool isPasswordField; // ✅ New flag for password fields
  final String? Function(String?)? validator;
  final VoidCallback?
  onTogglePassword; // ✅ Function for toggling password visibility

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      textEditingController.text =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: textEditingController,
      validator: validator,
      readOnly: isDatePicker,
      onTap: isDatePicker ? () => _selectDate(context) : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixIcon:
            isDatePicker
                ? IconButton(
                  icon: Icon(Icons.calendar_today, size: 20),
                  onPressed: () => _selectDate(context),
                )
                : isPasswordField
                ? IconButton(
                  // ✅ Only password fields use IconButton
                  icon: icon ?? Icon(Icons.visibility),
                  onPressed: onTogglePassword, // ✅ Calls toggle function
                )
                : icon, // ✅ Keeps normal icons as they are
      ),
    );
  }
}
