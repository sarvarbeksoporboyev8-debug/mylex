import 'package:flutter/material.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';

/// Security row widget with toggle switch
class SecurityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;

  const SecurityRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing16,
        vertical: SpacingTokens.spacing12,
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            size: SpacingTokens.spacing24,
            color: iconColor ?? const Color(0xFF101010),
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
          
          SpacingTokens.gapH12,
          
          // Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF21D07A),
          ),
        ],
      ),
    );
  }
}

/// Security row with divider
class SecurityRowWithDivider extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? iconColor;

  const SecurityRowWithDivider({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SecurityRow(
          icon: icon,
          title: title,
          subtitle: subtitle,
          value: value,
          onChanged: onChanged,
          iconColor: iconColor,
        ),
        const Divider(
          height: 1,
          thickness: 0.5,
          indent: SpacingTokens.spacing16,
          color: Color(0xFFEDEDED),
        ),
      ],
    );
  }
}
