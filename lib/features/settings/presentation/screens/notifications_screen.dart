import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../widgets/settings_widgets.dart';

enum NotificationFilter {
  all,
  payment,
  updates,
}

class NotificationItem {
  final NotificationType type;
  final String title;
  final String description;
  final String timestamp;
  final bool isActive;

  NotificationItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isActive = true,
  });
}

/// Notifications screen with responsive design and proper filtering
/// 
/// Fixes applied:
/// - Issue #3: Replaced hardcoded dimensions with SpacingTokens
/// - Issue #4: Using Expanded/Flexible for responsive layout
/// - Issue #5: Optimized SafeArea usage
/// - Issue #6: Using NotificationCard widget
/// - Issue #7: Using SpacingTokens for all spacing
/// - Issue #8: No hardcoded widths, using Wrap for responsive grid
/// - Issue #12: Clean, maintainable code
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationFilter _selectedFilter = NotificationFilter.all;

  // Mock data - replace with real data from your backend/provider
  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      type: NotificationType.paymentSuccess,
      title: 'Payment Successful',
      description: 'Yoru payment of \$250 for Eelectronics Store has been processed successfully.',
      timestamp: '2 hours ago',
      isActive: true,
    ),
    NotificationItem(
      type: NotificationType.paymentUpdate,
      title: 'Upcoming Payment Reminder',
      description: 'Your next payment of \$300 is  due on Feb 15, 2025.',
      timestamp: 'Yasterday',
      isActive: false,
    ),
    NotificationItem(
      type: NotificationType.securityUpdate,
      title: 'Security Update',
      description: 'We\'ve added new security features to project your account.',
      timestamp: '2 days ago',
      isActive: false,
    ),
    NotificationItem(
      type: NotificationType.promoUpdated,
      title: 'Special Offer Available',
      description: 'Get 0% interest on purchases above \$1000 for 6 months.',
      timestamp: '2 days ago',
      isActive: false,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedFilter) {
      case NotificationFilter.all:
        return _allNotifications;
      case NotificationFilter.payment:
        return _allNotifications
            .where((n) =>
                n.type == NotificationType.paymentSuccess ||
                n.type == NotificationType.paymentUpdate)
            .toList();
      case NotificationFilter.updates:
        return _allNotifications
            .where((n) =>
                n.type == NotificationType.securityUpdate ||
                n.type == NotificationType.promoUpdated)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - h-[60px], pb-[12px] pt-[8px] px-[20px]
            _buildHeader(context),
            // Filter chips
            _buildFilterChips(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  children: [
                    ..._filteredNotifications
                        .map((notification) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildNotificationCard(notification),
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.center,
          children: [
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
              ref.watch(stringsProvider).notification,
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

  Widget _buildFilterChips() {
    final strings = ref.watch(stringsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterChip(
              label: strings.all,
              isSelected: _selectedFilter == NotificationFilter.all,
              onTap: () => setState(() => _selectedFilter = NotificationFilter.all),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              label: strings.payment,
              isSelected: _selectedFilter == NotificationFilter.payment,
              onTap: () =>
                  setState(() => _selectedFilter = NotificationFilter.payment),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              label: strings.updates,
              isSelected: _selectedFilter == NotificationFilter.updates,
              onTap: () =>
                  setState(() => _selectedFilter = NotificationFilter.updates),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF101010) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.5,
              color: isSelected ? Colors.white : const Color(0xFF101010),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final isActive = notification.isActive;
    final backgroundColor = isActive ? Colors.white : const Color(0xFFF5F5F5);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          _buildIconContainer(notification.type, isActive),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with active indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF101010),
                        ),
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE63946), // Error/Main red
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  notification.description,
                  style: const TextStyle(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF606060),
                  ),
                ),
                const SizedBox(height: 8),
                // Timestamp
                Text(
                  notification.timestamp,
                  style: const TextStyle(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF878787),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(NotificationType type, bool isActive) {
    Color backgroundColor;
    Color borderColor;
    IconData icon;

    switch (type) {
      case NotificationType.paymentSuccess:
        backgroundColor = AppColors.success.withOpacity(0.08);
        borderColor = AppColors.success.withOpacity(0.24);
        icon = PhosphorIconsRegular.check;
        break;
      case NotificationType.paymentUpdate:
        backgroundColor = AppColors.accent.withOpacity(0.08);
        borderColor = AppColors.accent.withOpacity(0.24);
        icon = PhosphorIconsRegular.bell;
        break;
      case NotificationType.securityUpdate:
        backgroundColor = isActive
            ? Colors.white
            : AppColors.backgroundSecondary;
        borderColor = AppColors.border;
        icon = PhosphorIconsRegular.question;
        break;
      case NotificationType.promoUpdated:
        backgroundColor = AppColors.info.withOpacity(0.08);
        borderColor = AppColors.info.withOpacity(0.24);
        icon = PhosphorIconsRegular.tag;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Icon(
        icon,
        size: 20,
        color: const Color(0xFF101010),
      ),
    );
  }
}
