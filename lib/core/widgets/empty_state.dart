import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'glass_button.dart';

/// Empty state widget for various scenarios
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  /// No search results
  factory EmptyState.noResults({VoidCallback? onClear}) {
    return EmptyState(
      icon: PhosphorIconsRegular.magnifyingGlass,
      title: 'Natija topilmadi',
      description: 'Boshqa kalit so\'zlar bilan qidirib ko\'ring',
      actionLabel: onClear != null ? 'Tozalash' : null,
      onAction: onClear,
    );
  }

  /// No favorites
  factory EmptyState.noFavorites() {
    return const EmptyState(
      icon: PhosphorIconsRegular.heart,
      title: 'Sevimlilar yo\'q',
      description: 'Hujjatlarni sevimlilar ro\'yxatiga qo\'shing',
    );
  }

  /// No downloads
  factory EmptyState.noDownloads() {
    return const EmptyState(
      icon: PhosphorIconsRegular.downloadSimple,
      title: 'Yuklab olingan hujjatlar yo\'q',
      description: 'Hujjatlarni oflayn o\'qish uchun yuklab oling',
    );
  }

  /// No chat history
  factory EmptyState.noChats({VoidCallback? onNewChat}) {
    return EmptyState(
      icon: PhosphorIconsRegular.chatCircle,
      title: 'Suhbatlar yo\'q',
      description: 'Yangi suhbat boshlang',
      actionLabel: onNewChat != null ? 'Yangi suhbat' : null,
      onAction: onNewChat,
    );
  }

  /// Error state
  factory EmptyState.error({
    String? message,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      icon: PhosphorIconsRegular.warning,
      title: 'Xatolik yuz berdi',
      description: message ?? 'Iltimos, qayta urinib ko\'ring',
      actionLabel: onRetry != null ? 'Qayta urinish' : null,
      onAction: onRetry,
    );
  }

  /// No internet connection
  factory EmptyState.noConnection({VoidCallback? onRetry}) {
    return EmptyState(
      icon: PhosphorIconsRegular.wifiSlash,
      title: 'Internet aloqasi yo\'q',
      description: 'Tarmoq ulanishini tekshiring',
      actionLabel: onRetry != null ? 'Qayta urinish' : null,
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.glassFill,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(
                icon,
                size: 36,
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapVerticalL,
            Text(
              title,
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              AppSpacing.gapVerticalS,
              Text(
                description!,
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapVerticalL,
              SizedBox(
                width: 200,
                child: GlassButton(
                  text: actionLabel!,
                  onPressed: onAction,
                  isExpanded: false,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state with message
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
          if (message != null) ...[
            AppSpacing.gapVerticalL,
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
