import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';

/// A reusable menu item row for settings screens.
/// 
/// This widget provides a consistent row layout with optional icon,
/// label, trailing widget, and tap action.
class SettingsMenuItem extends StatelessWidget {
  /// Leading icon (optional)
  final IconData? icon;
  
  /// Icon size
  final double iconSize;
  
  /// Label text
  final String label;
  
  /// Label text color
  final Color labelColor;
  
  /// Font size for the label
  final double fontSize;
  
  /// Trailing widget (e.g., arrow, switch, value text)
  final Widget? trailing;
  
  /// Tap callback
  final VoidCallback? onTap;
  
  /// Row height
  final double height;
  
  /// Horizontal padding
  final double horizontalPadding;
  
  /// Gap between icon and text
  final double iconTextGap;

  const SettingsMenuItem({
    super.key,
    this.icon,
    this.iconSize = 20.0,
    required this.label,
    this.labelColor = const Color(0xFF101010),
    this.fontSize = 14.0,
    this.trailing,
    this.onTap,
    this.height = 52.0,
    this.horizontalPadding = 20.0,
    this.iconTextGap = 8.0,
  });

  /// Creates a menu item with a chevron trailing icon
  factory SettingsMenuItem.withChevron({
    Key? key,
    IconData? icon,
    double iconSize = 20.0,
    required String label,
    Color labelColor = const Color(0xFF101010),
    double fontSize = 14.0,
    VoidCallback? onTap,
    double height = 52.0,
    double horizontalPadding = 20.0,
    double iconTextGap = 8.0,
  }) {
    return SettingsMenuItem(
      key: key,
      icon: icon,
      iconSize: iconSize,
      label: label,
      labelColor: labelColor,
      fontSize: fontSize,
      onTap: onTap,
      height: height,
      horizontalPadding: horizontalPadding,
      iconTextGap: iconTextGap,
      trailing: const Icon(
        PhosphorIconsRegular.caretRight,
        size: 16,
        color: Color(0xFF878787),
      ),
    );
  }

  /// Creates a menu item displaying a static value
  factory SettingsMenuItem.withValue({
    Key? key,
    required String label,
    required String value,
    double fontSize = 14.0,
    double height = 52.0,
    double horizontalPadding = 12.0,
  }) {
    return SettingsMenuItem(
      key: key,
      label: label,
      fontSize: fontSize,
      height: height,
      horizontalPadding: horizontalPadding,
      trailing: Flexible(
        child: Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xFF606060),
            fontFamily: 'Roboto',
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: iconSize,
                    color: const Color(0xFF101010),
                  ),
                  SizedBox(width: iconTextGap),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                      color: labelColor,
                      fontFamily: 'Roboto',
                    ),
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

/// A simple divider for separating menu items
class SettingsMenuDivider extends StatelessWidget {
  final double leftInset;
  final double rightInset;
  final double height;
  final Color color;

  const SettingsMenuDivider({
    super.key,
    this.leftInset = 16.0,
    this.rightInset = 16.0,
    this.height = 0.5,
    this.color = AppColors.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: leftInset,
        right: rightInset,
      ),
      height: height,
      color: color,
    );
  }
}
