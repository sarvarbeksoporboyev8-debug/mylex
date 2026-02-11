import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Reusable section container for settings screens
/// 
/// Provides consistent styling for grouped settings items with
/// a header title and white background card.
class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SettingsSection({
    super.key,
    this.title,
    required this.children,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Padding(
            padding: margin ?? SpacingTokens.horizontalPadding20,
            child: Text(
              title!,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontSize: SpacingTokens.spacing14,
              ),
            ),
          ),
          SpacingTokens.verticalGap8,
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: SpacingTokens.borderRadius12,
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildChildrenWithDividers(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    if (children.isEmpty) return [];

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Padding(
            padding: SpacingTokens.horizontalPadding16,
            child: const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFEDEDED),
            ),
          ),
        );
      }
    }
    return result;
  }
}
