import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized [TextTheme] builder so both light and dark themes share
/// identical type scale/weights and only differ in color.
class AppTextStyles {
  const AppTextStyles._();

  static TextTheme textTheme(Color baseColor) {
    final base = GoogleFonts.interTextTheme();
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
          displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w700),
          headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
          headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 24),
          headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
          titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 18),
          titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall: base.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
          labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
          labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: 11),
        )
        .apply(
          bodyColor: baseColor,
          displayColor: baseColor,
        );
  }
}
