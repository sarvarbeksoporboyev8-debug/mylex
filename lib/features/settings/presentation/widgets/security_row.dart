import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Security settings row component
/// 
/// Displays a security setting with title, description, and toggle switch
class SecurityRow extends StatelessWidget {
  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final Color? iconColor;

  const SecurityRow({
    super.key,
    required this.title,
    this.description,
    required this.value,
    this.onChanged,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing12,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: SpacingTokens.spacing44,
              height: SpacingTokens.spacing44,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.accent).withOpacity(0.08),
                borderRadius: SpacingTokens.borderRadius10,
              ),
              child: Icon(
                icon,
                size: SpacingTokens.iconSize20,
                color: iconColor ?? AppColors.accent,
              ),
            ),
            SpacingTokens.horizontalGap12,
          ],
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
                if (description != null) ...[
                  SpacingTokens.verticalGap4,
                  Text(
                    description!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SpacingTokens.horizontalGap12,
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }
}
