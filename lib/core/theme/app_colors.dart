import 'package:flutter/material.dart';

/// Brand colors that fall outside Material 3's [ColorScheme] roles
/// (category tags, semantic status colors, subtle badges).
///
/// Exposed as a [ThemeExtension] so it flows through `Theme.of(context)`
/// alongside the rest of the theme and animates correctly between
/// light/dark and any future brand variants.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.categoryBlue,
    required this.categoryAmber,
    required this.categoryGreen,
    required this.categoryGrey,
    required this.shadow,
    required this.divider,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  final Color info;
  final Color infoContainer;

  // Service category accent colors (plumbing, electrical, heating, handyman).
  final Color categoryBlue;
  final Color categoryAmber;
  final Color categoryGreen;
  final Color categoryGrey;

  final Color shadow;
  final Color divider;

  static const AppColors light = AppColors(
    success: Color(0xFF2F8F5B),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFE3F3EA),
    onSuccessContainer: Color(0xFF123C2E),
    warning: Color(0xFFF59E0B),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFEF3C7),
    onWarningContainer: Color(0xFF92400E),
    info: Color(0xFF2563EB),
    infoContainer: Color(0xFFDBEAFE),
    categoryBlue: Color(0xFF2E7BE0),
    categoryAmber: Color(0xFFE0A72E),
    categoryGreen: Color(0xFF2F8F5B),
    categoryGrey: Color(0xFF6B7280),
    shadow: Color(0x1A0F1E14),
    divider: Color(0xFFE7EAEE),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF34D399),
    onSuccess: Color(0xFF05261A),
    successContainer: Color(0xFF16412C),
    onSuccessContainer: Color(0xFFBBF7D0),
    warning: Color(0xFFFBBF24),
    onWarning: Color(0xFF452B00),
    warningContainer: Color(0xFF78350F),
    onWarningContainer: Color(0xFFFDE68A),
    info: Color(0xFF60A5FA),
    infoContainer: Color(0xFF1E3A8A),
    categoryBlue: Color(0xFF5B9BF2),
    categoryAmber: Color(0xFFEBC15C),
    categoryGreen: Color(0xFF34D399),
    categoryGrey: Color(0xFF9CA3AF),
    shadow: Color(0x33000000),
    divider: Color(0xFF2A3441),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? categoryBlue,
    Color? categoryAmber,
    Color? categoryGreen,
    Color? categoryGrey,
    Color? shadow,
    Color? divider,
  }) {
    return AppColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      categoryBlue: categoryBlue ?? this.categoryBlue,
      categoryAmber: categoryAmber ?? this.categoryAmber,
      categoryGreen: categoryGreen ?? this.categoryGreen,
      categoryGrey: categoryGrey ?? this.categoryGrey,
      shadow: shadow ?? this.shadow,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      categoryBlue: Color.lerp(categoryBlue, other.categoryBlue, t)!,
      categoryAmber: Color.lerp(categoryAmber, other.categoryAmber, t)!,
      categoryGreen: Color.lerp(categoryGreen, other.categoryGreen, t)!,
      categoryGrey: Color.lerp(categoryGrey, other.categoryGrey, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
