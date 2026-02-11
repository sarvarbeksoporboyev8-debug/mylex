import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Premium glass-styled PIN keypad
class PinKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;
  final bool showBiometric;

  const PinKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onDelete,
    this.onBiometric,
    this.showBiometric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        AppSpacing.gapVerticalM,
        _buildRow(['4', '5', '6']),
        AppSpacing.gapVerticalM,
        _buildRow(['7', '8', '9']),
        AppSpacing.gapVerticalM,
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: _PinKey(
            label: key,
            onPressed: () => onKeyPressed(key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Biometric or empty
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: showBiometric && onBiometric != null
              ? _PinKey(
                  icon: Icons.fingerprint,
                  onPressed: onBiometric!,
                )
              : const SizedBox(width: 72, height: 72),
        ),
        // 0
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: _PinKey(
            label: '0',
            onPressed: () => onKeyPressed('0'),
          ),
        ),
        // Delete
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: _PinKey(
            icon: Icons.backspace_outlined,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

/// Individual PIN key button with glass effect
class _PinKey extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;

  const _PinKey({
    this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  State<_PinKey> createState() => _PinKeyState();
}

class _PinKeyState extends State<_PinKey> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 72,
        height: 72,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isPressed
                      ? [
                          AppColors.gold.withOpacity(0.3),
                          AppColors.gold.withOpacity(0.15),
                        ]
                      : [
                          AppColors.glassFillLight,
                          AppColors.glassFill,
                        ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isPressed
                      ? AppColors.gold.withOpacity(0.5)
                      : AppColors.glassBorder,
                  width: 1,
                ),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.label != null
                    ? Text(
                        widget.label!,
                        style: AppTypography.headlineSmall.copyWith(
                          color: _isPressed
                              ? AppColors.gold
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        size: 28,
                        color: _isPressed
                            ? AppColors.gold
                            : AppColors.textSecondary,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// PIN dots indicator
class PinDots extends StatelessWidget {
  final int length;
  final int filledCount;
  final bool hasError;

  const PinDots({
    super.key,
    this.length = AppConstants.pinLength,
    required this.filledCount,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
          width: isFilled ? 16 : 14,
          height: isFilled ? 16 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasError
                ? AppColors.error
                : isFilled
                    ? AppColors.gold
                    : Colors.transparent,
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : isFilled
                      ? AppColors.gold
                      : AppColors.glassBorderLight,
              width: 2,
            ),
            boxShadow: isFilled && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
