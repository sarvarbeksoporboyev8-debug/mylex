import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Card variant types
enum GlassCardVariant {
  standard,
  meta,
  content,
}

/// Clean card with very soft shadow - Claude style
/// 
/// - White background
/// - Very rounded corners (20-24px)
/// - Barely visible shadow
/// - Generous padding
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool showShadow;
  final bool showBorder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GlassCardVariant variant;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = 20.0,
    this.showShadow = true,
    this.showBorder = false,
    this.onTap,
    this.onLongPress,
    this.variant = GlassCardVariant.standard,
    this.backgroundColor,
  });

  /// Meta card - for metadata sections
  const GlassCard.meta({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
  })  : borderRadius = 20.0,
        showShadow = true,
        showBorder = false,
        variant = GlassCardVariant.meta;

  /// Content card - for main content
  const GlassCard.content({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
  })  : borderRadius = 24.0,
        showShadow = true,
        showBorder = false,
        variant = GlassCardVariant.content;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: AppColors.border, width: 1)
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      );
    }

    return card;
  }
}

/// Simple surface with border - for inputs, subtle containers
class GlassSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? fillColor;
  final VoidCallback? onTap;

  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16.0,
    this.fillColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Container(
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: surface,
      );
    }

    return surface;
  }
}

/// Content sheet for scrollable areas
class GlassContentSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double topRadius;

  const GlassContentSheet({
    super.key,
    required this.child,
    this.padding,
    this.topRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(24),
      child: child,
    );
  }
}

/// Card with highlight - kept for compatibility
class GlassCardHighlight extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassCardHighlight({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(borderRadius),
              ),
            ),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
