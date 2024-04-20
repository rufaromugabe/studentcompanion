import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF64FFDA),
    primaryColorDark: Color(0xFF455A64),
    primaryColorLight: Color(0xFF2F3C7E),
    backgroundColor: Color(0xFFFCFCFC),
    canvasColor: Color(0xFFFFFFFF),
    errorColor: Color(0xFFB00020),
    listTileTheme: ListTileThemeData(iconColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    )),
    textTheme: TextTheme(
      headline1: TextStyle(color: Color(0xFF212121)),
      headline2: TextStyle(color: Color(0xFF212121)),
      bodyText1: TextStyle(color: Color(0xFF212121)),
      bodyText2: TextStyle(color: Color(0xFF212121)),
    ),
  );
}
