import 'dart:core';
import 'package:adminpanal/local/cache_helper.dart';
import 'package:flutter/cupertino.dart';


class DarkThemeProvider with ChangeNotifier {

  DarkThemePrefs darkThemePrefs=DarkThemePrefs();
  bool _darkTheme= false;

  bool get getDarkTheme => _darkTheme;

  set setDarkTheme (bool value){
    _darkTheme= value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();
  }


}




