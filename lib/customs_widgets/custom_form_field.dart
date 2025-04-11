import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({

    this.icon,
    required this.hintText,
    required this.keyboardType,
    required this.label,
    required this.textEditingController,
    this.obscureText = false,
    this.isPasswordField = false,
    this.validator,
    this.isDatePicker = false,
    this.onTogglePassword,
    required this.focusNode ,
    required this.textInputAction  ,
    this.readOnly = false,
    this.maxLine  ,

    super.key,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final TextInputAction textInputAction ;
  final Widget? icon; // ✅ Accepts both `Icon` and `IconButton`
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isDatePicker;
  final bool isPasswordField; // ✅ New flag for password fields
  final String? Function(String?)? validator;
  final VoidCallback?  onTogglePassword;
  final  int? maxLine;
  final FocusNode focusNode;// ✅ Function for toggling password visibility
  final bool readOnly ;


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
maxLines:  maxLine,
      focusNode: focusNode,
      textInputAction : textInputAction ,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: textEditingController,
      validator: validator,
        readOnly: readOnly || isDatePicker ,
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
