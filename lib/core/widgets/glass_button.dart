import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Primary gold gradient button with glossy effect
class GoldButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double height;

  const GoldButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height = 52,
  });

  @override
  State<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.height,
        width: widget.isExpanded ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isExpanded ? 0 : AppSpacing.l,
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: widget.onPressed != null
              ? AppColors.buttonGradient
              : LinearGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.5),
                    AppColors.goldDark.withOpacity(0.5),
                  ],
                ),
          borderRadius: AppSpacing.borderRadiusFull,
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(_isPressed ? 0.2 : 0.4),
              blurRadius: _isPressed ? 8 : 16,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Top highlight line
            Positioned(
              top: 1,
              left: 20,
              right: 20,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.textOnGold),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: AppColors.textOnGold,
                            size: 20,
                          ),
                          AppSpacing.gapHorizontalS,
                        ],
                        Text(
                          widget.text,
                          style: AppTypography.button,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Secondary glass outline button
class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double height;
  final Color? textColor;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height = 52,
    this.textColor,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.height,
        width: widget.isExpanded ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: widget.isExpanded ? 0 : AppSpacing.l,
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: AppSpacing.borderRadiusFull,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: _isPressed
                    ? AppColors.glassFillLight
                    : AppColors.glassFill,
                borderRadius: AppSpacing.borderRadiusFull,
                border: Border.all(
                  color: AppColors.glassBorderLight,
                  width: 1,
                ),
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(AppColors.textPrimary),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.textColor ?? AppColors.textPrimary,
                              size: 20,
                            ),
                            AppSpacing.gapHorizontalS,
                          ],
                          Text(
                            widget.text,
                            style: AppTypography.button.copyWith(
                              color: widget.textColor ?? AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small icon button with glass effect
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final String? tooltip;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
    this.iconColor,
    this.tooltip,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: _isPressed
                    ? AppColors.glassFillLight
                    : AppColors.glassFill,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  color: widget.iconColor ?? AppColors.textPrimary,
                  size: widget.size * 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Animated action chip for quick actions
class GlassChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const GlassChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withOpacity(0.2)
              : AppColors.glassFill,
          borderRadius: AppSpacing.borderRadiusFull,
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.glassBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.gold : AppColors.textSecondary,
              ),
              AppSpacing.gapHorizontalXs,
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.gold : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 150.ms);
  }
}
