import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Clean background wrapper - Claude style
/// 
/// Warm neutral background (#F5F5F4)
class GoldBackground extends StatelessWidget {
  final Widget child;
  final bool showRays;
  final bool showNoise;
  final bool useGrayBackground;

  const GoldBackground({
    super.key,
    required this.child,
    this.showRays = false,
    this.showNoise = false,
    this.useGrayBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: child,
    );
  }
}

/// Animated version (kept for compatibility)
class AnimatedGoldBackground extends StatelessWidget {
  final Widget child;
  final bool showRays;
  final bool showNoise;

  const AnimatedGoldBackground({
    super.key,
    required this.child,
    this.showRays = false,
    this.showNoise = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: child,
    );
  }
}

/// Simple blue header background for screens
class BlueHeaderBackground extends StatelessWidget {
  final Widget child;
  final double headerHeight;

  const BlueHeaderBackground({
    super.key,
    required this.child,
    this.headerHeight = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blue header portion
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * headerHeight,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
          ),
        ),
        // Gray background below
        Positioned(
          top: MediaQuery.of(context).size.height * headerHeight - 20,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
        ),
        // Content
        Positioned.fill(child: child),
      ],
    );
  }
}
