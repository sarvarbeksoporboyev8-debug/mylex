import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/models/settings_models.dart';

/// Profile header component for settings screen
/// 
/// Displays user avatar, name, phone number, and edit button
/// in a consistent, reusable format.
class ProfileHeader extends StatelessWidget {
  final UserProfileModel profile;
  final VoidCallback? onEditTap;
  final VoidCallback? onBackTap;
  final String editButtonLabel;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onEditTap,
    this.onBackTap,
    this.editButtonLabel = 'Edit',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing8,
      ),
      child: Row(
        children: [
          // Back arrow (optional)
          if (onBackTap != null) ...[
            GestureDetector(
              onTap: onBackTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: SpacingTokens.spacing44,
                height: SpacingTokens.spacing44,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEDEDED)),
                  borderRadius: SpacingTokens.borderRadius10,
                  color: AppColors.cardBackground,
                ),
                child: const Icon(
                  PhosphorIconsRegular.caretLeft,
                  size: SpacingTokens.iconSize20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SpacingTokens.horizontalGap8,
          ],
          // Avatar
          Container(
            width: SpacingTokens.spacing44,
            height: SpacingTokens.spacing44,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.08),
              borderRadius: SpacingTokens.borderRadius32,
            ),
            child: profile.avatarUrl != null
                ? ClipRRect(
                    borderRadius: SpacingTokens.borderRadius32,
                    child: Image.network(
                      profile.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          PhosphorIconsRegular.user,
                          color: AppColors.accent,
                        );
                      },
                    ),
                  )
                : const Icon(
                    PhosphorIconsRegular.user,
                    color: AppColors.accent,
                  ),
          ),
          SpacingTokens.horizontalGap8,
          // Name + Phone/Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SpacingTokens.verticalGap2,
                Text(
                  profile.email ?? profile.phoneNumber,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit button (optional)
          if (onEditTap != null) ...[
            SpacingTokens.horizontalGap8,
            OutlinedButton.icon(
              onPressed: onEditTap,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, SpacingTokens.spacing32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(
                  horizontal: SpacingTokens.spacing12,
                  vertical: SpacingTokens.spacing6,
                ),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: Color(0xFFEDEDED)),
                shape: RoundedRectangleBorder(
                  borderRadius: SpacingTokens.borderRadius8,
                ),
              ),
              icon: const Icon(
                PhosphorIconsRegular.pencilSimple,
                size: SpacingTokens.iconSize16,
                color: AppColors.textPrimary,
              ),
              label: Text(
                editButtonLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
