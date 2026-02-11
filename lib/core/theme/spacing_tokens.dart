import 'package:flutter/material.dart';

/// Comprehensive spacing token system for responsive design
/// 
/// This replaces ALL hardcoded spacing values with semantic tokens
/// following an 8px grid system with extended values for specific use cases.
/// 
/// Usage:
/// - Replace hardcoded: height: 60 → height: SpacingTokens.spacing60
/// - Replace hardcoded: padding: 20 → padding: SpacingTokens.padding20
/// - Replace hardcoded: SizedBox(height: 12) → SpacingTokens.verticalGap12
class SpacingTokens {
  SpacingTokens._();

  // ============================================================
  // BASE SPACING VALUES (8px grid + extensions)
  // ============================================================
  
  /// 2px - Micro spacing
  static const double spacing2 = 2.0;
  
  /// 4px - Extra small spacing (half grid)
  static const double spacing4 = 4.0;
  
  /// 6px - Small-medium spacing
  static const double spacing6 = 6.0;
  
  /// 7px - Fine-tuned spacing
  static const double spacing7 = 7.0;
  
  /// 8px - Small spacing (1x grid base)
  static const double spacing8 = 8.0;
  
  /// 10px - Small-medium spacing
  static const double spacing10 = 10.0;
  
  /// 12px - Medium spacing (1.5x grid)
  static const double spacing12 = 12.0;
  
  /// 14px - Medium-large spacing
  static const double spacing14 = 14.0;
  
  /// 16px - Large spacing (2x grid)
  static const double spacing16 = 16.0;
  
  /// 18px - Large-extra spacing
  static const double spacing18 = 18.0;
  
  /// 20px - Extra large spacing (2.5x grid)
  static const double spacing20 = 20.0;
  
  /// 24px - XXL spacing (3x grid)
  static const double spacing24 = 24.0;
  
  /// 32px - XXXL spacing (4x grid)
  static const double spacing32 = 32.0;
  
  /// 40px - Large component spacing
  static const double spacing40 = 40.0;
  
  /// 43px - Specific component height
  static const double spacing43 = 43.0;
  
  /// 44px - Touch target size (iOS standard)
  static const double spacing44 = 44.0;
  
  /// 48px - Large touch target
  static const double spacing48 = 48.0;
  
  /// 52px - Row height
  static const double spacing52 = 52.0;
  
  /// 56px - Large row height
  static const double spacing56 = 56.0;
  
  /// 60px - Header height
  static const double spacing60 = 60.0;
  
  /// 88px - Large header height
  static const double spacing88 = 88.0;
  
  /// 106px - Extra large component
  static const double spacing106 = 106.0;
  
  /// 129px - Specific layout height
  static const double spacing129 = 129.0;
  
  /// 131px - Specific layout height
  static const double spacing131 = 131.0;
  
  /// 133px - Specific layout height
  static const double spacing133 = 133.0;

  // ============================================================
  // BORDER RADIUS VALUES
  // ============================================================
  
  /// 6px - Extra small radius
  static const double radius6 = 6.0;
  
  /// 8px - Small radius
  static const double radius8 = 8.0;
  
  /// 10px - Medium-small radius
  static const double radius10 = 10.0;
  
  /// 12px - Medium radius
  static const double radius12 = 12.0;
  
  /// 14px - Medium-large radius
  static const double radius14 = 14.0;
  
  /// 16px - Large radius
  static const double radius16 = 16.0;
  
  /// 18px - Extra large radius
  static const double radius18 = 18.0;
  
  /// 20px - XXL radius
  static const double radius20 = 20.0;
  
  /// 32px - Circle/pill radius
  static const double radius32 = 32.0;
  
  /// 999px - Full circle radius
  static const double radiusFull = 999.0;

  // ============================================================
  // EDGE INSETS (Padding/Margin presets)
  // ============================================================
  
  // Uniform padding
  static const EdgeInsets padding2 = EdgeInsets.all(spacing2);
  static const EdgeInsets padding4 = EdgeInsets.all(spacing4);
  static const EdgeInsets padding6 = EdgeInsets.all(spacing6);
  static const EdgeInsets padding8 = EdgeInsets.all(spacing8);
  static const EdgeInsets padding10 = EdgeInsets.all(spacing10);
  static const EdgeInsets padding12 = EdgeInsets.all(spacing12);
  static const EdgeInsets padding14 = EdgeInsets.all(spacing14);
  static const EdgeInsets padding16 = EdgeInsets.all(spacing16);
  static const EdgeInsets padding18 = EdgeInsets.all(spacing18);
  static const EdgeInsets padding20 = EdgeInsets.all(spacing20);
  static const EdgeInsets padding24 = EdgeInsets.all(spacing24);
  static const EdgeInsets padding32 = EdgeInsets.all(spacing32);

  // Horizontal padding
  static const EdgeInsets horizontalPadding4 = EdgeInsets.symmetric(horizontal: spacing4);
  static const EdgeInsets horizontalPadding8 = EdgeInsets.symmetric(horizontal: spacing8);
  static const EdgeInsets horizontalPadding12 = EdgeInsets.symmetric(horizontal: spacing12);
  static const EdgeInsets horizontalPadding16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets horizontalPadding20 = EdgeInsets.symmetric(horizontal: spacing20);
  static const EdgeInsets horizontalPadding24 = EdgeInsets.symmetric(horizontal: spacing24);
  static const EdgeInsets horizontalPadding32 = EdgeInsets.symmetric(horizontal: spacing32);

  // Vertical padding
  static const EdgeInsets verticalPadding4 = EdgeInsets.symmetric(vertical: spacing4);
  static const EdgeInsets verticalPadding6 = EdgeInsets.symmetric(vertical: spacing6);
  static const EdgeInsets verticalPadding8 = EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets verticalPadding12 = EdgeInsets.symmetric(vertical: spacing12);
  static const EdgeInsets verticalPadding16 = EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets verticalPadding20 = EdgeInsets.symmetric(vertical: spacing20);

  // ============================================================
  // SIZED BOX GAPS (Spacer widgets)
  // ============================================================
  
  // Vertical gaps
  static const SizedBox verticalGap2 = SizedBox(height: spacing2);
  static const SizedBox verticalGap4 = SizedBox(height: spacing4);
  static const SizedBox verticalGap6 = SizedBox(height: spacing6);
  static const SizedBox verticalGap8 = SizedBox(height: spacing8);
  static const SizedBox verticalGap10 = SizedBox(height: spacing10);
  static const SizedBox verticalGap12 = SizedBox(height: spacing12);
  static const SizedBox verticalGap14 = SizedBox(height: spacing14);
  static const SizedBox verticalGap16 = SizedBox(height: spacing16);
  static const SizedBox verticalGap18 = SizedBox(height: spacing18);
  static const SizedBox verticalGap20 = SizedBox(height: spacing20);
  static const SizedBox verticalGap24 = SizedBox(height: spacing24);
  static const SizedBox verticalGap32 = SizedBox(height: spacing32);

  // Horizontal gaps
  static const SizedBox horizontalGap2 = SizedBox(width: spacing2);
  static const SizedBox horizontalGap4 = SizedBox(width: spacing4);
  static const SizedBox horizontalGap6 = SizedBox(width: spacing6);
  static const SizedBox horizontalGap8 = SizedBox(width: spacing8);
  static const SizedBox horizontalGap10 = SizedBox(width: spacing10);
  static const SizedBox horizontalGap12 = SizedBox(width: spacing12);
  static const SizedBox horizontalGap14 = SizedBox(width: spacing14);
  static const SizedBox horizontalGap16 = SizedBox(width: spacing16);
  static const SizedBox horizontalGap20 = SizedBox(width: spacing20);
  static const SizedBox horizontalGap24 = SizedBox(width: spacing24);

  // ============================================================
  // BORDER RADIUS PRESETS
  // ============================================================
  
  static BorderRadius get borderRadius6 => BorderRadius.circular(radius6);
  static BorderRadius get borderRadius8 => BorderRadius.circular(radius8);
  static BorderRadius get borderRadius10 => BorderRadius.circular(radius10);
  static BorderRadius get borderRadius12 => BorderRadius.circular(radius12);
  static BorderRadius get borderRadius14 => BorderRadius.circular(radius14);
  static BorderRadius get borderRadius16 => BorderRadius.circular(radius16);
  static BorderRadius get borderRadius18 => BorderRadius.circular(radius18);
  static BorderRadius get borderRadius20 => BorderRadius.circular(radius20);
  static BorderRadius get borderRadius32 => BorderRadius.circular(radius32);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ============================================================
  // RESPONSIVE CONSTRAINTS
  // ============================================================
  
  /// Max content width for tablets/desktop (prevents text stretching)
  static const double maxContentWidth = 560.0;
  
  /// Max width for large screens
  static const double maxScreenWidth = 1200.0;
  
  /// Min touch target size (accessibility)
  static const double minTouchTarget = 44.0;

  // ============================================================
  // ICON SIZES
  // ============================================================
  
  static const double iconSize16 = 16.0;
  static const double iconSize20 = 20.0;
  static const double iconSize24 = 24.0;
  static const double iconSize32 = 32.0;
  static const double iconSize40 = 40.0;
  static const double iconSize44 = 44.0;
}
