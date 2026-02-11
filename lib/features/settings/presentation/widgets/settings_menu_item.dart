import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';

/// A reusable menu item widget for settings screens.
/// Provides consistent styling for clickable menu rows with icons and trailing widgets.
class SettingsMenuItem extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color labelColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double? height;

  const SettingsMenuItem({
    super.key,
    this.icon,
    required this.label,
    this.labelColor = const Color(0xFF101010),
    this.trailing,
    this.onTap,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: SpacingTokens.paddingHorizontal20,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: SpacingTokens.iconSize,
                    color: const Color(0xFF101010),
                  ),
                  SpacingTokens.gapH8,
                ],
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF101010),
                      fontFamily: 'Roboto',
                    ).merge(TextStyle(color: labelColor)),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A divider widget for separating menu items within a section.
class SettingsMenuDivider extends StatelessWidget {
  final double indent;

  const SettingsMenuDivider({
    super.key,
    this.indent = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: indent, right: indent),
      height: 0.5,
      color: AppColors.divider,
    );
  }
}
