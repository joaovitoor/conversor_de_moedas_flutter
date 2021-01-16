import 'package:flutter/material.dart';

class Controller extends ChangeNotifier{
  static Controller instance = Controller();

  bool isDartTheme = false;
  changeTheme(){
    isDartTheme = !isDartTheme;
    notifyListeners();
  }


}
