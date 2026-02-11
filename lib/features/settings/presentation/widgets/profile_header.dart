import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

/// Profile header widget for settings screen
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing20,
        vertical: SpacingTokens.spacing12,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: SpacingTokens.spacing56,
            height: SpacingTokens.spacing56,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: SpacingTokens.borderRadius12,
            ),
            child: avatarUrl != null
                ? ClipRRect(
                    borderRadius: SpacingTokens.borderRadius12,
                    child: Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    PhosphorIconsRegular.user,
                    size: 28,
                    color: AppColors.accent,
                  ),
          ),
          SpacingTokens.gapH12,
          // Name and email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyLarge.copyWith(
                    color: const Color(0xFF101010),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SpacingTokens.gapV2,
                Text(
                  email,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF606060),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SpacingTokens.gapH8,
          // Edit button
          if (onEditPressed != null)
            OutlinedButton.icon(
              onPressed: onEditPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.spacing12,
                  vertical: SpacingTokens.spacing8,
                ),
                side: const BorderSide(color: Color(0xFFEDEDED)),
                shape: RoundedRectangleBorder(
                  borderRadius: SpacingTokens.borderRadius8,
                ),
              ),
              icon: const Icon(
                PhosphorIconsRegular.pencilSimple,
                size: 16,
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

/// Pinned profile header for CustomScrollView
class PinnedProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final VoidCallback? onEditPressed;

  const PinnedProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SpacingTokens.spacing88,
      child: ProfileHeader(
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        onEditPressed: onEditPressed,
      ),
    );
  }
}
