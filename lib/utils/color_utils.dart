import 'dart:math';

import 'package:flutter/material.dart';

Color generateDarkColor() {
  final double randomDouble = Random().nextDouble() * 0.5;
  final double opacity = randomDouble;
  final int red = Random().nextInt(128);
  final int green = Random().nextInt(128);
  final int blue = Random().nextInt(128);

  return Color.fromARGB((opacity * 255).toInt(), red, green, blue);
}
