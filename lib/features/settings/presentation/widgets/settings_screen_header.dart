import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// A reusable settings screen header with back button and title.
/// 
/// This widget provides a consistent header layout for settings screens.
class SettingsScreenHeader extends StatelessWidget {
  /// The title to display in the header
  final String title;
  
  /// Whether to show the back button
  final bool showBackButton;
  
  /// The height of the header
  final double height;
  
  /// The horizontal padding
  final double horizontalPadding;

  const SettingsScreenHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.height = 60,
    this.horizontalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEDEDED)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      PhosphorIconsRegular.caretLeft,
                      size: 20,
                      color: Color(0xFF101010),
                    ),
                  ),
                ),
              ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.5,
                color: Color(0xFF101010),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
