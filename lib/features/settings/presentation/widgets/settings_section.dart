import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A reusable section container for settings screens.
/// 
/// This widget provides a consistent container with optional title,
/// white background, rounded corners, and border styling.
class SettingsSection extends StatelessWidget {
  /// The title displayed above the section container
  final String? title;
  
  /// The content to display inside the section
  final Widget child;
  
  /// Border radius for the container
  final double borderRadius;
  
  /// Font size for the section title
  final double titleFontSize;
  
  /// Horizontal padding for the section content
  final double horizontalPadding;

  const SettingsSection({
    super.key,
    this.title,
    required this.child,
    this.borderRadius = 12.0,
    this.titleFontSize = 14.0,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 8,
            ),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: child,
        ),
      ],
    );
  }
}
