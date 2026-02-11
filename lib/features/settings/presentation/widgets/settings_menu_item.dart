import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable settings menu item with icon, title, subtitle, and optional trailing widget
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showDivider;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      onTap: onTap,
      borderRadius: SpacingTokens.borderRadius12,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing12,
          vertical: SpacingTokens.spacing14,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: SpacingTokens.spacing40,
              height: SpacingTokens.spacing40,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                borderRadius: SpacingTokens.borderRadius8,
                border: Border.all(color: const Color(0xFFF5F5F5)),
              ),
              child: Icon(
                icon,
                size: SpacingTokens.spacing20,
                color: iconColor ?? const Color(0xFF101010),
              ),
            ),
            SpacingTokens.gapH12,
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF101010),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SpacingTokens.gapV2,
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: const Color(0xFF606060),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing widget or arrow
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                PhosphorIconsRegular.caretRight,
                size: 20,
                color: Color(0xFF606060),
              ),
          ],
        ),
      ),
    );

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: SpacingTokens.spacing16,
            color: Color(0xFFEDEDED),
          ),
        ],
      );
    }

    return content;
  }
}
