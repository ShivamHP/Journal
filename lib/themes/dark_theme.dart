import 'package:flutter/material.dart';

ThemeData DarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
  );
}

List<int> darkCardColors() {
  List<int> dark_colors = [
    0xffb39ddb,
    0xff9fa8da,
    0xffafd6a7,
    0xffdce775,
    0xffffcc80,
    0xff4dd0e1,
  ];
  return dark_colors;
}
