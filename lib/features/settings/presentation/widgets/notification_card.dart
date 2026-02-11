import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

/// Notification type enum
enum NotificationType {
  paymentSuccess,
  paymentUpdate,
  securityUpdate,
  promoUpdated,
}

/// Notification card widget for displaying notification items
class NotificationCard extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String description;
  final String timestamp;
  final bool isActive;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isActive = false,
    this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case NotificationType.paymentSuccess:
        return PhosphorIconsRegular.checkCircle;
      case NotificationType.paymentUpdate:
        return PhosphorIconsRegular.clockCounterClockwise;
      case NotificationType.securityUpdate:
        return PhosphorIconsRegular.shieldCheck;
      case NotificationType.promoUpdated:
        return PhosphorIconsRegular.gift;
    }
  }

  Color get _iconColor {
    switch (type) {
      case NotificationType.paymentSuccess:
        return const Color(0xFF21D07A);
      case NotificationType.paymentUpdate:
        return AppColors.accent;
      case NotificationType.securityUpdate:
        return const Color(0xFF3B82F6);
      case NotificationType.promoUpdated:
        return const Color(0xFFEC4899);
    }
  }

  Color get _backgroundColor {
    switch (type) {
      case NotificationType.paymentSuccess:
        return const Color(0xFFE7FFF8);
      case NotificationType.paymentUpdate:
        return AppColors.accent.withOpacity(0.1);
      case NotificationType.securityUpdate:
        return const Color(0xFFDCEEFF);
      case NotificationType.promoUpdated:
        return const Color(0xFFFCE7F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: SpacingTokens.borderRadius12,
      child: Container(
        padding: SpacingTokens.padding12,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFAFAFA) : Colors.white,
          borderRadius: SpacingTokens.borderRadius12,
          border: Border.all(
            color: isActive ? AppColors.accent.withOpacity(0.2) : const Color(0xFFEDEDED),
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
                color: _backgroundColor,
                borderRadius: SpacingTokens.borderRadius8,
              ),
              child: Icon(
                _icon,
                size: SpacingTokens.spacing20,
                color: _iconColor,
              ),
            ),
            
            SpacingTokens.gapH12,
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF101010),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SpacingTokens.gapV4,
                  
                  // Description
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF606060),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SpacingTokens.gapV8,
                  
                  // Timestamp
                  Text(
                    timestamp,
                    style: AppTypography.bodySmall.copyWith(
                      color: const Color(0xFF909090),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            
            // Active indicator
            if (isActive)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: SpacingTokens.spacing6),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
