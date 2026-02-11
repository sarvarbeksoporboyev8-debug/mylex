import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Reusable menu item component for settings screens
/// 
/// Displays an icon, title, optional subtitle, and trailing widget
/// with consistent styling and tap behavior.
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool showChevron;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing20,
          vertical: SpacingTokens.spacing12,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: SpacingTokens.spacing44,
              height: SpacingTokens.spacing44,
              decoration: BoxDecoration(
                color: backgroundColor ??
                    (iconColor ?? AppColors.accent).withOpacity(0.08),
                borderRadius: SpacingTokens.borderRadius10,
              ),
              child: Icon(
                icon,
                size: SpacingTokens.iconSize20,
                color: iconColor ?? AppColors.accent,
              ),
            ),
            SpacingTokens.horizontalGap12,
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SpacingTokens.verticalGap4,
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing widget
            if (trailing != null) ...[
              SpacingTokens.horizontalGap8,
              trailing!,
            ] else if (showChevron && onTap != null) ...[
              SpacingTokens.horizontalGap8,
              Icon(
                PhosphorIconsRegular.caretRight,
                size: SpacingTokens.iconSize20,
                color: AppColors.textTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
