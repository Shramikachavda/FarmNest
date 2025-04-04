import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleTheme extends ChangeNotifier{
  bool isDarkMode = false;

 ThemeMode get theme => isDarkMode  ?  ThemeMode.dark :ThemeMode.light ;

  void toggleTheme(){
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}