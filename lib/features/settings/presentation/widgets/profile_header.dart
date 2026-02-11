import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';

/// A reusable profile header widget for the settings screen.
/// Displays user avatar, name, phone, and edit button.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;
  final Widget? avatar;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    this.onBackPressed,
    this.onEditPressed,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing8,
      ),
      child: Row(
        children: [
          // Back button
          if (onBackPressed != null) ...[
            GestureDetector(
              onTap: onBackPressed,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEDEDED)),
                  borderRadius: SpacingTokens.borderRadiusLarge,
                  color: Colors.white,
                ),
                child: const Icon(
                  PhosphorIconsRegular.caretLeft,
                  size: SpacingTokens.iconSize,
                  color: Color(0xFF101010),
                ),
              ),
            ),
            SpacingTokens.gapH8,
          ],
          // Avatar
          avatar ??
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.08),
                  borderRadius: SpacingTokens.borderRadiusFull,
                ),
                child: const Icon(
                  PhosphorIconsRegular.user,
                  color: AppColors.accent,
                ),
              ),
          SpacingTokens.gapH8,
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
                SpacingTokens.gapV2,
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
          if (onEditPressed != null)
            OutlinedButton.icon(
              onPressed: onEditPressed,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.spacing12,
                  vertical: SpacingTokens.spacing6,
                ),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: Color(0xFFEDEDED)),
                shape: RoundedRectangleBorder(
                  borderRadius: SpacingTokens.borderRadiusMedium,
                ),
              ),
              icon: const Icon(
                PhosphorIconsRegular.pencilSimple,
                size: SpacingTokens.iconSizeSmall,
                color: Color(0xFF101010),
              ),
              label: const Text(
                'Edit',
                style: TextStyle(
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
