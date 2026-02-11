import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/providers/settings_providers.dart';
import '../widgets/notification_card.dart';

enum NotificationFilter {
  all,
  payment,
  security,
  account,
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;

  String? get _filterType {
    switch (_selectedFilter) {
      case NotificationFilter.all:
        return null;
      case NotificationFilter.payment:
        return 'payment';
      case NotificationFilter.security:
        return 'security';
      case NotificationFilter.account:
        return 'account';
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final notifications = ref.watch(filteredNotificationsProvider(_filterType));
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, strings, unreadCount),
            // Filter chips
            _buildFilterChips(strings),
            // Notifications list
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState(strings)
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () {
                            ref
                                .read(notificationsProvider.notifier)
                                .markAsRead(notification.id);
                          },
                          onDismiss: () {
                            ref
                                .read(notificationsProvider.notifier)
                                .removeNotification(notification.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings, int unreadCount) {
    return SizedBox(
      height: SpacingTokens.spacing60,
      child: Padding(
        padding: SpacingTokens.horizontalPadding20,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
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
            Expanded(
              child: Text(
                strings.notifications,
                textAlign: TextAlign.center,
                style: AppTypography.headline4.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: SpacingTokens.spacing44),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(AppStrings strings) {
    return Container(
      height: SpacingTokens.spacing60,
      padding: SpacingTokens.horizontalPadding20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            label: strings.all,
            filter: NotificationFilter.all,
          ),
          SpacingTokens.horizontalGap8,
          _buildFilterChip(
            label: 'Payment',
            filter: NotificationFilter.payment,
          ),
          SpacingTokens.horizontalGap8,
          _buildFilterChip(
            label: 'Security',
            filter: NotificationFilter.security,
          ),
          SpacingTokens.horizontalGap8,
          _buildFilterChip(
            label: 'Account',
            filter: NotificationFilter.account,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required NotificationFilter filter,
  }) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
      },
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.accent.withOpacity(0.1),
      checkmarkColor: AppColors.accent,
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isSelected ? AppColors.accent : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: SpacingTokens.borderRadius10,
        side: BorderSide(
          color: isSelected ? AppColors.accent : const Color(0xFFEDEDED),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppStrings strings) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIconsRegular.bellSlash,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          SpacingTokens.verticalGap16,
          Text(
            'No notifications',
            style: AppTypography.headline4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SpacingTokens.verticalGap8,
          Text(
            'You\'re all caught up!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
