import 'package:flutter/material.dart';
import 'package:journal/backends/database.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:journal/screens/onboarding_screen.dart';
import 'package:journal/themes/dark_theme.dart';
import 'package:journal/themes/light_theme.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
        theme: LightTheme(),
        debugShowCheckedModeBanner: false,
        darkTheme: DarkTheme(),
        themeMode: ThemeMode.dark,
        home: 0 == 1 ? OnboardingScreen() : HomeScreen()),
  );
}
