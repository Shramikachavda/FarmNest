import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    this.icon,
    required this.hintText,
    required this.keyboardType,
    required this.label,
    required this.textEditingController,
    this.obscureText = false,
    this.validator,
    this.isDatePicker = false, // New parameter for date picker
    super.key,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final Icon? icon;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isDatePicker; // Flag to check if it's a date field
  final String? Function(String?)? validator;

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: textEditingController,
        validator: validator,
        readOnly: isDatePicker,
        onTap: isDatePicker ? () => _selectDate(context) : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          //   hintStyle: Theme.of(context).textTheme.bodySmall,
          // labelStyle: Theme.of(context).textTheme.bodySmall,
          suffixIcon:
              isDatePicker
                  ? IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      size: 20,
                    ), // Reduce icon size
                    onPressed: () => _selectDate(context),
                  )
                  : icon,
        ),
      ),
    );
  }
}
