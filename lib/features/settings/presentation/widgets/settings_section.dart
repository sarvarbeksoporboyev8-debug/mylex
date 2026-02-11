import 'package:flutter/material.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';

/// Reusable settings section with title and content
class SettingsSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SettingsSection({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: SpacingTokens.paddingHorizontal20,
              child: Text(
                title!,
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF606060),
                  fontSize: 14,
                ),
              ),
            ),
            SpacingTokens.gapV8,
          ],
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: SpacingTokens.borderRadius12,
              border: Border.all(color: const Color(0xFFEDEDED)),
            ),
            padding: padding ?? SpacingTokens.padding12,
            child: child,
          ),
        ],
      ),
    );
  }
}
