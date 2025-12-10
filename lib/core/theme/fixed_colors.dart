import 'package:flutter/material.dart';

@immutable
class FixedColors extends ThemeExtension<FixedColors> {
  const FixedColors({
    required this.brandColor,
    required this.secondColor
  });
  final Color? brandColor;
  final Color? secondColor;

  static const FixedColors constant = FixedColors(
    brandColor: Color(0xFFFF5055),
    secondColor: Color(0xFFDCDBCD),

  );

  @override
  FixedColors copyWith({Color? brandColor}) =>
      FixedColors(
        brandColor: brandColor ?? this.brandColor,
        secondColor: secondColor ?? this.secondColor  
      );

  @override
  FixedColors lerp(ThemeExtension<FixedColors>? other, double t) {
    if (other is! FixedColors) return this;
    return FixedColors(
      brandColor: Color.lerp(brandColor, other.brandColor, t),
      secondColor: Color.lerp(secondColor, other.secondColor, t)
    );
  }
}
