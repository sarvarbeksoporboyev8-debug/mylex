import 'package:flutter/material.dart';

/// Design tokens for spacing to ensure consistency across the app.
/// Based on an 8px grid system for systematic spacing.
///
/// Usage:
/// ```dart
/// padding: EdgeInsets.all(SpacingTokens.spacing16)
/// SizedBox(height: SpacingTokens.spacing12)
/// ```
class SpacingTokens {
  SpacingTokens._();

  // Base spacing values (8px grid)
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
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
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // Component-specific spacing
  static const double iconSize = 20.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 24.0;
  
  // Border radius values
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 10.0;
  static const double radiusXLarge = 12.0;
  static const double radiusXXLarge = 14.0;
  static const double radiusFull = 32.0;

  // Common EdgeInsets presets
  static const EdgeInsets padding4 = EdgeInsets.all(spacing4);
  static const EdgeInsets padding8 = EdgeInsets.all(spacing8);
  static const EdgeInsets padding12 = EdgeInsets.all(spacing12);
  static const EdgeInsets padding16 = EdgeInsets.all(spacing16);
  static const EdgeInsets padding20 = EdgeInsets.all(spacing20);
  static const EdgeInsets padding24 = EdgeInsets.all(spacing24);

  static const EdgeInsets paddingHorizontal8 = EdgeInsets.symmetric(horizontal: spacing8);
  static const EdgeInsets paddingHorizontal12 = EdgeInsets.symmetric(horizontal: spacing12);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontal20 = EdgeInsets.symmetric(horizontal: spacing20);

  static const EdgeInsets paddingVertical4 = EdgeInsets.symmetric(vertical: spacing4);
  static const EdgeInsets paddingVertical6 = EdgeInsets.symmetric(vertical: spacing6);
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVertical12 = EdgeInsets.symmetric(vertical: spacing12);
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(vertical: spacing16);

  // Common SizedBox gaps
  static const SizedBox gap2 = SizedBox(width: spacing2, height: spacing2);
  static const SizedBox gap4 = SizedBox(width: spacing4, height: spacing4);
  static const SizedBox gap6 = SizedBox(width: spacing6, height: spacing6);
  static const SizedBox gap8 = SizedBox(width: spacing8, height: spacing8);
  static const SizedBox gap10 = SizedBox(width: spacing10, height: spacing10);
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
  static const SizedBox gapV10 = SizedBox(height: spacing10);
  static const SizedBox gapV12 = SizedBox(height: spacing12);
  static const SizedBox gapV16 = SizedBox(height: spacing16);
  static const SizedBox gapV20 = SizedBox(height: spacing20);
  static const SizedBox gapV24 = SizedBox(height: spacing24);
  static const SizedBox gapV32 = SizedBox(height: spacing32);

  // BorderRadius presets
  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge => BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusXXLarge => BorderRadius.circular(radiusXXLarge);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);
}
