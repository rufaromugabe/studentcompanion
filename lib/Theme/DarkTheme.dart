import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    secondaryHeaderColor: Colors.amber,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF2F3C7E),
    primaryColorDark: const Color(0xFF1A1D23),
    primaryColorLight: const Color(0xFF455A64),
    canvasColor: const Color(0xFF2F3C7E),
    scaffoldBackgroundColor: const Color(0xFF1A1D23),
    cardColor: const Color(0xFFB00020),
    listTileTheme: const ListTileThemeData(iconColor: Colors.deepPurple),
    iconTheme: const IconThemeData(color: Colors.deepPurple),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
    )),
  );
}
