import 'package:flutter/material.dart';

/// Centralized spacing design tokens for consistent layout across the app.
/// Based on 4px base unit with 8px grid system.
///
/// Usage:
/// ```dart
/// SizedBox(height: SpacingTokens.spacing16)
/// Padding(padding: SpacingTokens.paddingHorizontal20)
/// BorderRadius.circular(SpacingTokens.radius12)
/// ```
class SpacingTokens {
  SpacingTokens._();

  // Base spacing values (4px increments)
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing7 = 7.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing14 = 14.0;
  static const double spacing16 = 16.0;
  static const double spacing18 = 18.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing28 = 28.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing43 = 43.0;
  static const double spacing44 = 44.0;
  static const double spacing48 = 48.0;
  static const double spacing52 = 52.0;
  static const double spacing56 = 56.0;
  static const double spacing60 = 60.0;
  static const double spacing88 = 88.0;

  // Border radius values
  static const double radius4 = 4.0;
  static const double radius6 = 6.0;
  static const double radius8 = 8.0;
  static const double radius10 = 10.0;
  static const double radius12 = 12.0;
  static const double radius14 = 14.0;
  static const double radius16 = 16.0;
  static const double radius18 = 18.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radius32 = 32.0;

  // Common padding values
  static const EdgeInsets padding4 = EdgeInsets.all(spacing4);
  static const EdgeInsets padding8 = EdgeInsets.all(spacing8);
  static const EdgeInsets padding12 = EdgeInsets.all(spacing12);
  static const EdgeInsets padding16 = EdgeInsets.all(spacing16);
  static const EdgeInsets padding20 = EdgeInsets.all(spacing20);
  static const EdgeInsets padding24 = EdgeInsets.all(spacing24);

  // Horizontal padding
  static const EdgeInsets paddingHorizontal8 = EdgeInsets.symmetric(horizontal: spacing8);
  static const EdgeInsets paddingHorizontal12 = EdgeInsets.symmetric(horizontal: spacing12);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontal20 = EdgeInsets.symmetric(horizontal: spacing20);
  static const EdgeInsets paddingHorizontal24 = EdgeInsets.symmetric(horizontal: spacing24);

  // Vertical padding
  static const EdgeInsets paddingVertical4 = EdgeInsets.symmetric(vertical: spacing4);
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVertical12 = EdgeInsets.symmetric(vertical: spacing12);
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets paddingVertical20 = EdgeInsets.symmetric(vertical: spacing20);

  // Gap widgets for Row/Column
  static const SizedBox gap2 = SizedBox(width: spacing2, height: spacing2);
  static const SizedBox gap4 = SizedBox(width: spacing4, height: spacing4);
  static const SizedBox gap6 = SizedBox(width: spacing6, height: spacing6);
  static const SizedBox gap8 = SizedBox(width: spacing8, height: spacing8);
  static const SizedBox gap12 = SizedBox(width: spacing12, height: spacing12);
  static const SizedBox gap16 = SizedBox(width: spacing16, height: spacing16);
  static const SizedBox gap20 = SizedBox(width: spacing20, height: spacing20);
  static const SizedBox gap24 = SizedBox(width: spacing24, height: spacing24);

  // Horizontal gaps
  static const SizedBox gapH4 = SizedBox(width: spacing4);
  static const SizedBox gapH8 = SizedBox(width: spacing8);
  static const SizedBox gapH12 = SizedBox(width: spacing12);
  static const SizedBox gapH16 = SizedBox(width: spacing16);
  static const SizedBox gapH20 = SizedBox(width: spacing20);

  // Vertical gaps
  static const SizedBox gapV2 = SizedBox(height: spacing2);
  static const SizedBox gapV4 = SizedBox(height: spacing4);
  static const SizedBox gapV6 = SizedBox(height: spacing6);
  static const SizedBox gapV8 = SizedBox(height: spacing8);
  static const SizedBox gapV12 = SizedBox(height: spacing12);
  static const SizedBox gapV16 = SizedBox(height: spacing16);
  static const SizedBox gapV20 = SizedBox(height: spacing20);
  static const SizedBox gapV24 = SizedBox(height: spacing24);
  static const SizedBox gapV32 = SizedBox(height: spacing32);

  // Border radius
  static BorderRadius get borderRadius4 => BorderRadius.circular(radius4);
  static BorderRadius get borderRadius8 => BorderRadius.circular(radius8);
  static BorderRadius get borderRadius12 => BorderRadius.circular(radius12);
  static BorderRadius get borderRadius14 => BorderRadius.circular(radius14);
  static BorderRadius get borderRadius16 => BorderRadius.circular(radius16);
  static BorderRadius get borderRadius20 => BorderRadius.circular(radius20);

  // Responsive constraints
  static const double maxContentWidth = 600.0;
  static const double maxFormWidth = 480.0;
  static const double maxCardWidth = 430.0;

  /// Get responsive horizontal padding based on screen width
  static EdgeInsets responsiveHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return paddingHorizontal24;
    if (screenWidth > 600) return paddingHorizontal20;
    return paddingHorizontal16;
  }

  /// Get responsive content padding based on screen width
  static EdgeInsets responsiveContentPadding(double screenWidth) {
    if (screenWidth > 1200) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: spacing24);
    }
    if (screenWidth > 600) {
      return const EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing20);
    }
    return const EdgeInsets.symmetric(horizontal: spacing20, vertical: spacing16);
  }
}
