import 'package:flutter/material.dart';

@immutable
class VariableColors extends ThemeExtension<VariableColors> {
  const VariableColors({
    required this.brand,
    required this.background100,
    required this.background200,
    required this.textColor100,
  });
  final Color? brand;
  final Color? background100;
  final Color? background200;
  final Color? textColor100;

  static const VariableColors light = VariableColors(
    brand: Color(0xFFFF5055), //로고 등 브랜드 컬러
    background100: Color(0xFFDCDBCD), //기본 백그라운
    background200: Color(0xFFFFFFFF), //바텀내비,기본 박스 
    textColor100: Color(0xFF000000), //
  );

  @override
  VariableColors copyWith({
    Color? background100,
    Color? background200,
    Color? background300,
  }) => VariableColors(
    brand: brand ?? this.brand,
    background100: background100 ?? this.background100,
    background200: background300 ?? this.background200,
    textColor100: textColor100 ?? this.textColor100,
  );

  @override
  VariableColors lerp(ThemeExtension<VariableColors>? other, double t) {
    if (other is! VariableColors) return this;
    return VariableColors(
      brand: Color.lerp(brand, other.brand, t),
      background100: Color.lerp(background100, other.background100, t),
      background200: Color.lerp(background200, other.background200, t),
      textColor100: Color.lerp(textColor100, other.textColor100, t),
    );
  }
}
