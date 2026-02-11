import 'package:flutter/material.dart';

/// Lex.uz AI color palette - Perplexity-inspired teal style
/// 
/// Clean, modern, teal accent
class AppColors {
  AppColors._();

  // ============================================================
  // BACKGROUND COLORS - Clean whites and light grays
  // ============================================================
  
  /// Main background - off-white
  static const Color background = Color(0xFFFAFAFA);
  
  /// Secondary background - light gray
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  
  /// Card/surface background - white
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  /// Chat user bubble - light gray
  static const Color userBubble = Color(0xFFF0F0F0);
  
  /// Chat AI - no background (transparent)
  static const Color assistantBubble = Colors.transparent;

  // Legacy aliases
  static const Color backgroundDark = Color(0xFFEEEEEE);
  static const Color backgroundMid = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFAFAFA);

  // ============================================================
  // ACCENT COLOR - Perplexity teal
  // ============================================================
  
  /// Primary accent - teal
  static const Color accent = Color(0xFF20B2AA);
  
  /// Lighter accent
  static const Color accentLight = Color(0xFF40C4BC);
  
  /// Darker accent
  static const Color accentDark = Color(0xFF1A9A94);

  // Legacy aliases
  static const Color primary = accent;
  static const Color primaryDark = accentDark;
  static const Color gold = accent;
  static const Color goldLight = accentLight;
  static const Color goldDark = accentDark;
  static const Color goldAccent = accent;
  static const Color secondary = accent;

  // ============================================================
  // TEXT COLORS - Dark grays, not pure black
  // ============================================================
  
  /// Primary text - dark gray
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Secondary text - medium gray
  static const Color textSecondary = Color(0xFF6B6B6B);
  
  /// Tertiary/hint text - light gray
  static const Color textTertiary = Color(0xFF9B9B9B);
  
  /// Text on accent background
  static const Color textOnAccent = Color(0xFFFFFFFF);
  
  /// Text on primary (legacy)
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnGold = Color(0xFFFFFFFF);

  // ============================================================
  // BORDER & DIVIDER - Barely visible
  // ============================================================
  
  /// Divider - very subtle
  static const Color divider = Color(0xFFE8E8E6);
  
  /// Border - barely visible
  static const Color border = Color(0xFFE0E0DE);
  
  /// Glass border (legacy)
  static const Color glassBorder = Color(0xFFE8E8E6);
  static const Color glassBorderLight = Color(0xFFE0E0DE);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  // ============================================================
  // SHADOW - Very soft
  // ============================================================
  
  static const Color shadowColor = Color(0x0A000000); // Very subtle

  // ============================================================
  // GLASS/SURFACE (legacy compatibility)
  // ============================================================
  
  static const Color glassFill = Color(0xFFFFFFFF);
  static const Color glassFillLight = Color(0xFFFAFAF9);

  // ============================================================
  // ACTION GREEN (for CTA buttons)
  // ============================================================
  
  static const Color actionGreen = Color(0xFF4CAF50);

  // ============================================================
  // GRADIENTS - Subtle or none
  // ============================================================
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accent],
  );

  static const LinearGradient goldGradient = primaryGradient;
  static const LinearGradient accentGradient = primaryGradient;

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, background],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accent, accentDark],
  );

  static const RadialGradient goldRaysGradient = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.5,
    colors: [
      Color(0x2020B2AA),
      Color(0x1020B2AA),
      Color(0x0520B2AA),
      Color(0x0020B2AA),
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, Color(0xFFFAFAF9)],
  );
}
