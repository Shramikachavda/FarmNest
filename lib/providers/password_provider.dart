import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  bool isObscure = true;

  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}

class ConfirmPasswordProvider with ChangeNotifier {
  bool isObscure = true;

  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
