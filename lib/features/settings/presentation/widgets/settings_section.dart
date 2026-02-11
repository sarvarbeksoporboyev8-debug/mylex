import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

/// A reusable section container widget for settings screens.
/// Provides consistent styling for grouping related settings items.
class SettingsSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({
    super.key,
    this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              bottom: SpacingTokens.spacing4,
              left: SpacingTokens.spacing4,
            ),
            child: Text(
              title!,
              style: AppTypography.bodySmall.copyWith(
                color: const Color(0xFF606060),
              ),
            ),
          ),
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SpacingTokens.borderRadiusXLarge,
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: padding != null ? Padding(padding: padding!, child: child) : child,
        ),
      ],
    );
  }
}
