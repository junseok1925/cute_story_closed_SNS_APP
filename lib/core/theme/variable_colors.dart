import 'package:flutter/material.dart';

@immutable
class VariableColors extends ThemeExtension<VariableColors> {
  const VariableColors({
    required this.background100,
    required this.background200,
    required this.shadow,
    required this.textColor100,
    required this.textColor200,
    required this.textColor300,
  });
  final Color? background100;
  final Color? background200;
  final Color? shadow;
  final Color? textColor100;
  final Color? textColor200;
  final Color? textColor300;

  static const VariableColors light = VariableColors(
    background100: Color(0xFFEDF0F4), //기본 백그라운
    background200: Color(0xFFFFFFFF), // 박스 백그라운
    shadow: Colors.black87,
    textColor100: Color(0xFF000000),
    textColor200: Color(0xFFE8FCF1),
    textColor300: Color(0xFF555555),
  );
  static const VariableColors dark = VariableColors(
    background100: Color(0xFF39393C), //기본 백그라운
    background200: Color(0xFF49494C), //박스 백그라운
    shadow: Colors.white70,
    textColor100: Color(0xFFE8FCF1),
    textColor200: Color(0xFF000000),
    textColor300: Color(0xFF8A8A8A),
  );

  @override
  VariableColors copyWith({
    Color? background100,
    Color? background200,
    Color? background300,
  }) => VariableColors(
    background100: background100 ?? this.background100,
    background200: background200 ?? this.background200,
    shadow: shadow ?? this.shadow,
    textColor100: textColor100 ?? this.textColor100,
    textColor200: textColor200 ?? this.textColor200,
    textColor300: textColor200 ?? this.textColor300,
  );

  @override
  VariableColors lerp(ThemeExtension<VariableColors>? other, double t) {
    if (other is! VariableColors) return this;
    return VariableColors(
      background100: Color.lerp(background100, other.background100, t),
      background200: Color.lerp(background200, other.background200, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      textColor100: Color.lerp(textColor100, other.textColor100, t),
      textColor200: Color.lerp(textColor200, other.textColor200, t),
      textColor300: Color.lerp(textColor300, other.textColor300, t),
    );
  }
}
