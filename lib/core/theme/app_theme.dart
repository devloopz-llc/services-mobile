import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// App-wide [ThemeData] for light and dark mode.
///
/// Colors are hand-tuned (not seed-generated) so they match the approved
/// brand design: a deep green primary for high-emphasis actions and a
/// mint-green container for badges/selected states.
class AppTheme {
  const AppTheme._();

  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF123C2E),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE3F3EA),
    onPrimaryContainer: Color(0xFF123C2E),
    secondary: Color(0xFF2F8F5B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCEFE4),
    onSecondaryContainer: Color(0xFF1B4332),
    tertiary: Color(0xFFF59E0B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF92400E),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF991B1B),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF12181F),
    surfaceContainerHighest: Color(0xFFF3F5F7),
    onSurfaceVariant: Color(0xFF6B7280),
    outline: Color(0xFFE2E5EA),
    outlineVariant: Color(0xFFEDEFF2),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF12181F),
    onInverseSurface: Color(0xFFF3F5F7),
    inversePrimary: Color(0xFF9AD8B6),
    surfaceTint: Color(0xFF123C2E),
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF34D399),
    onPrimary: Color(0xFF05261A),
    primaryContainer: Color(0xFF14532D),
    onPrimaryContainer: Color(0xFFBBF7D0),
    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF052E1C),
    secondaryContainer: Color(0xFF16412C),
    onSecondaryContainer: Color(0xFFBBF7D0),
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF452B00),
    tertiaryContainer: Color(0xFF78350F),
    onTertiaryContainer: Color(0xFFFDE68A),
    error: Color(0xFFF87171),
    onError: Color(0xFF450A0A),
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFECACA),
    surface: Color(0xFF12181F),
    onSurface: Color(0xFFE5E7EB),
    surfaceContainerHighest: Color(0xFF1E2530),
    onSurfaceVariant: Color(0xFF9CA3AF),
    outline: Color(0xFF2A3441),
    outlineVariant: Color(0xFF232B36),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE5E7EB),
    onInverseSurface: Color(0xFF12181F),
    inversePrimary: Color(0xFF123C2E),
    surfaceTint: Color(0xFF34D399),
  );

  static ThemeData get light => _build(_lightScheme, AppColors.light);
  static ThemeData get dark => _build(_darkScheme, AppColors.dark);

  static ThemeData _build(ColorScheme scheme, AppColors appColors) {
    final textTheme = AppTextStyles.textTheme(scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      fontFamily: textTheme.bodyMedium?.fontFamily,
      extensions: [appColors],
      splashFactory: InkSparkle.splashFactory,
      dividerTheme: DividerThemeData(color: appColors.divider, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.error, width: 1.2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size.fromHeight(52),
          textStyle: textTheme.titleSmall,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.titleSmall,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.titleSmall,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary,
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: scheme.onPrimary),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
