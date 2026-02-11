import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// A reusable profile header widget for settings screens.
/// 
/// This widget displays a back button, user avatar, name, phone,
/// and an edit button in a consistent layout.
class SettingsProfileHeader extends StatelessWidget {
  /// User's full name
  final String name;
  
  /// User's phone number
  final String phone;
  
  /// Edit button label
  final String editLabel;
  
  /// Route to navigate to when edit is tapped
  final String editRoute;
  
  /// Whether to show the back button
  final bool showBackButton;
  
  /// Horizontal padding
  final double horizontalPadding;

  const SettingsProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.editLabel,
    required this.editRoute,
    this.showBackButton = true,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Row(
        children: [
          // Back arrow
          if (showBackButton) ...[
            GestureDetector(
              onTap: () => context.pop(),
              behavior: HitTestBehavior.opaque,
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
            const SizedBox(width: 8),
          ],
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              PhosphorIconsRegular.user,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          // Name + Phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101010),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          OutlinedButton.icon(
            onPressed: () => context.push(editRoute),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: Color(0xFFEDEDED)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(
              PhosphorIconsRegular.pencilSimple,
              size: 16,
              color: Color(0xFF101010),
            ),
            label: Text(
              editLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF101010),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
