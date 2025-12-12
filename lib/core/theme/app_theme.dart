// app_theme.dart
import 'package:cute_story_closed_sns_app/core/theme/fixed_colors.dart';
import 'package:cute_story_closed_sns_app/core/theme/variable_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    extensions: const [VariableColors.light, FixedColors.constant],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    extensions: const [VariableColors.dark, FixedColors.constant],
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
    ),
  );
}

VariableColors vrc(BuildContext context) =>
    Theme.of(context).extension<VariableColors>()!;

FixedColors fxc(BuildContext context) =>
    Theme.of(context).extension<FixedColors>()!;
