import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF2F3C7E),
    primaryColorDark: Color(0xFF1A1D23),
    primaryColorLight: Color(0xFF455A64),
    backgroundColor: Color(0xFF1A1D23),
    canvasColor: Color(0xFF2F3C7E),
    scaffoldBackgroundColor: Color(0xFF1A1D23),
    errorColor: Color(0xFFB00020),
    listTileTheme: ListTileThemeData(iconColor: Colors.deepPurple),
    iconTheme: IconThemeData(color: Colors.deepPurple),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
    )),
    textTheme: TextTheme(
      headline1: TextStyle(color: Color(0xFFFFFFFF)),
      headline2: TextStyle(color: Color(0xFFFFFFFF)),
      bodyText1: TextStyle(color: Color(0xFFFFFFFF)),
      bodyText2: TextStyle(color: Color(0xFFFFFFFF)),
    ),
  );
}
