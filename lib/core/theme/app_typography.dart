import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system - Perplexity-inspired clean style
/// 
/// Inter/System font, clean weights, good readability
class AppTypography {
  AppTypography._();

  // System font - SF Pro on iOS, Roboto on Android
  static const String? _fontFamily = null; // null = system default

  // ============================================================
  // SCREEN TITLES - 32px, prominent
  // ============================================================
  
  static TextStyle get screenTitle => TextStyle(
        
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get screenTitleWhite => TextStyle(
        
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.5,
        color: Colors.white,
      );

  // ============================================================
  // HEADLINES - Large, clear hierarchy
  // ============================================================

  static TextStyle get headlineLarge => TextStyle(
        
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => TextStyle(
        
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => TextStyle(
        
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // TITLES - Card headers, section titles
  // ============================================================

  static TextStyle get titleLarge => TextStyle(
        
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => TextStyle(
        
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => TextStyle(
        
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  // Card title alias
  static TextStyle get cardTitle => titleLarge;
  static TextStyle get contentHeading => titleLarge;
  static TextStyle get articleHeading => titleMedium;

  // ============================================================
  // BODY TEXT - 18px base, very readable
  // ============================================================

  static TextStyle get bodyLarge => TextStyle(
        
        fontSize: 19,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => TextStyle(
        
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => TextStyle(
        
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
      );

  /// Legal/document body text
  static TextStyle get legalBody => TextStyle(
        
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.7,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // LABELS - Smaller but still readable
  // ============================================================

  static TextStyle get labelLarge => TextStyle(
        
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => TextStyle(
        
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelSmall => TextStyle(
        
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textTertiary,
      );

  // ============================================================
  // META - For metadata, captions
  // ============================================================

  static TextStyle get metaLabel => TextStyle(
        
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: AppColors.textTertiary,
      );

  static TextStyle get metaValue => TextStyle(
        
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => TextStyle(
        
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AppColors.textTertiary,
      );

  // ============================================================
  // BUTTONS - 18px, clear
  // ============================================================

  static TextStyle get button => TextStyle(
        
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: 0.2,
        color: AppColors.textOnAccent,
      );

  // ============================================================
  // CHIPS/TAGS - Removed oval pills, but keep style for any remaining
  // ============================================================

  static TextStyle get chip => TextStyle(
        
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: AppColors.textSecondary,
      );

  // ============================================================
  // DISPLAY - Extra large
  // ============================================================

  static TextStyle get displayLarge => TextStyle(
        
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => TextStyle(
        
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => TextStyle(
        
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // NUMERIC - For numbers, stats
  // ============================================================

  static TextStyle get numericLarge => TextStyle(
        
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get numericMedium => TextStyle(
        
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  // ============================================================
  // TAB STYLES
  // ============================================================

  static TextStyle get tabInactive => TextStyle(
        
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: AppColors.textTertiary,
      );

  static TextStyle get tabActive => TextStyle(
        
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.accent,
      );

  // Bullet text alias
  static TextStyle get bulletText => bodyMedium;

  // ============================================================
  // TEXT THEME FOR MATERIAL
  // ============================================================

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
