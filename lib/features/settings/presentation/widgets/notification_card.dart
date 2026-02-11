import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/models/settings_models.dart';
import 'package:intl/intl.dart';

/// Notification card component
/// 
/// Displays individual notification with icon, title, message, and timestamp
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: SpacingTokens.horizontalPadding20,
        color: AppColors.error,
        child: const Icon(
          PhosphorIconsRegular.trash,
          color: Colors.white,
          size: SpacingTokens.iconSize24,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: SpacingTokens.padding16,
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.cardBackground
                : AppColors.accent.withOpacity(0.03),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFEDEDED),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: SpacingTokens.spacing40,
                height: SpacingTokens.spacing40,
                decoration: BoxDecoration(
                  color: _getIconColor().withOpacity(0.1),
                  borderRadius: SpacingTokens.borderRadius10,
                ),
                child: Icon(
                  _getIcon(),
                  size: SpacingTokens.iconSize20,
                  color: _getIconColor(),
                ),
              ),
              SpacingTokens.horizontalGap12,
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          SpacingTokens.horizontalGap8,
                          Container(
                            width: SpacingTokens.spacing8,
                            height: SpacingTokens.spacing8,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SpacingTokens.verticalGap4,
                    Text(
                      notification.message,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SpacingTokens.verticalGap4,
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case 'payment':
        return PhosphorIconsRegular.coins;
      case 'security':
        return PhosphorIconsRegular.shield;
      case 'account':
        return PhosphorIconsRegular.user;
      case 'promotion':
        return PhosphorIconsRegular.gift;
      default:
        return PhosphorIconsRegular.bell;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case 'payment':
        return AppColors.success;
      case 'security':
        return AppColors.warning;
      case 'account':
        return AppColors.accent;
      case 'promotion':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
