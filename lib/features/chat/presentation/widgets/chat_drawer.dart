import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';

/// Chat sidebar - Perplexity style
/// 
/// Slide-in panel from left, matches Settings sheet design language
class ChatDrawer extends ConsumerWidget {
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelectThread;
  final bool isFullScreen;

  const ChatDrawer({
    super.key,
    required this.onNewChat,
    required this.onSelectThread,
    this.isFullScreen = false,
  });

  // Layout constants matching iOS HIG / Perplexity specs
  static const double _sidebarWidthRatio = 0.82;
  static const double _cornerRadius = 16.0;
  static const double _horizontalInset = 20.0;
  static const double _rowHeight = 56.0;
  static const double _headerHeight = 56.0;
  static const double _iconSize = 20.0;
  static const double _iconTextGap = 14.0;
  static const double _titleFontSize = 17.0;
  static const double _rowFontSize = 17.0;
  static const double _secondaryFontSize = 13.0;
  static const double _dividerInsetLeft = 56.0;
  static const double _dividerInsetRight = 16.0;
  static const Color _backgroundColor = Color(0xFFFDFCF8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final threadsAsync = ref.watch(chatThreadsProvider);
    final activeThreadId = ref.watch(activeThreadIdProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: isFullScreen ? screenWidth : screenWidth * _sidebarWidthRatio,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: isFullScreen
            ? null
            : const BorderRadius.only(
                topRight: Radius.circular(_cornerRadius),
                bottomRight: Radius.circular(_cornerRadius),
              ),
      ),
      child: SafeArea(
        left: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context, strings),
            
            // Divider under header
            Container(height: 0.5, color: AppColors.divider),
            
            // Chat list
            Expanded(
              child: threadsAsync.when(
                data: (grouped) => _buildThreadsList(
                  context,
                  grouped,
                  activeThreadId,
                  strings,
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(_horizontalInset),
                    child: Text(
                      '${strings.error}: $error',
                      style: TextStyle(
                        fontSize: _secondaryFontSize,
                        color: AppColors.error,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Footer divider
            Container(height: 0.5, color: AppColors.divider),
            
            // Footer actions
            _buildFooter(context, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings) {
    return SizedBox(
      height: _headerHeight,
      child: Row(
        children: [
          // Close button (X) with 44x44 touch target
          SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: Icon(
                      PhosphorIconsRegular.x,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Title
          Expanded(
            child: Center(
              child: Text(
                strings.chatHistory,
                style: TextStyle(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          // Balance for symmetry
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildThreadsList(
    BuildContext context,
    Map<String, List<ChatThread>> grouped,
    String? activeThreadId,
    AppStrings strings,
  ) {
    final hasToday = grouped['today']?.isNotEmpty ?? false;
    final hasThisWeek = grouped['thisWeek']?.isNotEmpty ?? false;
    final hasOlder = grouped['older']?.isNotEmpty ?? false;

    if (!hasToday && !hasThisWeek && !hasOlder) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.chatCircle,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              strings.noChats,
              style: TextStyle(
                fontSize: _rowFontSize,
                color: AppColors.textSecondary,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.startNewChat,
              style: TextStyle(
                fontSize: _secondaryFontSize,
                color: AppColors.textTertiary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      );
    }

    final List<Widget> items = [];

    if (hasToday) {
      items.add(_buildSectionHeader(strings.today));
      final todayThreads = grouped['today']!;
      for (int i = 0; i < todayThreads.length; i++) {
        items.add(_buildThreadRow(
          context,
          todayThreads[i],
          todayThreads[i].id == activeThreadId,
        ));
        if (i < todayThreads.length - 1) {
          items.add(_buildInsetDivider());
        }
      }
    }

    if (hasThisWeek) {
      items.add(_buildSectionHeader(strings.thisWeek));
      final weekThreads = grouped['thisWeek']!;
      for (int i = 0; i < weekThreads.length; i++) {
        items.add(_buildThreadRow(
          context,
          weekThreads[i],
          weekThreads[i].id == activeThreadId,
        ));
        if (i < weekThreads.length - 1) {
          items.add(_buildInsetDivider());
        }
      }
    }

    if (hasOlder) {
      items.add(_buildSectionHeader(strings.older));
      final olderThreads = grouped['older']!;
      for (int i = 0; i < olderThreads.length; i++) {
        items.add(_buildThreadRow(
          context,
          olderThreads[i],
          olderThreads[i].id == activeThreadId,
        ));
        if (i < olderThreads.length - 1) {
          items.add(_buildInsetDivider());
        }
      }
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: items,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _horizontalInset,
        right: _horizontalInset,
        top: 28,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _secondaryFontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildThreadRow(BuildContext context, ChatThread thread, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onSelectThread(thread.id);
        },
        child: SizedBox(
          height: _rowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
            child: Row(
              children: [
                Icon(
                  PhosphorIconsRegular.chatCircle,
                  size: _iconSize,
                  color: isActive ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: _iconTextGap),
                Expanded(
                  child: Text(
                    thread.title,
                    style: TextStyle(
                      fontSize: _rowFontSize,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                      color: isActive ? AppColors.accent : AppColors.textPrimary,
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsetDivider() {
    return Container(
      margin: const EdgeInsets.only(
        left: _dividerInsetLeft,
        right: _dividerInsetRight,
      ),
      height: 0.5,
      color: AppColors.divider,
    );
  }

  Widget _buildFooter(BuildContext context, AppStrings strings) {
    return Column(
      children: [
        // New Chat action row
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
              onNewChat();
            },
            child: SizedBox(
              height: _rowHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _horizontalInset),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.plus,
                      size: _iconSize,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: _iconTextGap),
                    Text(
                      strings.newChat,
                      style: TextStyle(
                        fontSize: _rowFontSize,
                        fontWeight: FontWeight.w400,
                        color: AppColors.accent,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Bottom safe area padding
        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
      ],
    );
  }
}
