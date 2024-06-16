import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF64FFDA),
    primaryColorDark: const Color(0xFF455A64),
    primaryColorLight: const Color(0xFF2F3C7E),
    canvasColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xFFB00020),
    listTileTheme: const ListTileThemeData(
        iconColor: Colors.white, textColor: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
    )),
  );
}
