import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/localization/app_language.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_model.dart';

class ChatHistoryScreen extends ConsumerWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final threadsAsync = ref.watch(chatThreadsProvider);
    final activeThreadId = ref.watch(activeThreadIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar: X on the left, History centered
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  // Close (X)
                  IconButton(
                    icon: Icon(
                      PhosphorIconsRegular.x,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        strings.chatHistory,
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // balance for centered title
                ],
              ),
            ),

            // Search + filter row (BrainBox-style)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIconsRegular.magnifyingGlass,
                            size: 18,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Search...',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      PhosphorIconsRegular.slidersHorizontal,
                      size: 20,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            // History list
            Expanded(
              child: threadsAsync.when(
                data: (grouped) => _HistoryList(
                  grouped: grouped,
                  activeThreadId: activeThreadId,
                  onSelectThread: (threadId) {
                    ref.read(activeThreadIdProvider.notifier).state = threadId;
                    Navigator.of(context).pop();
                  },
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 2,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${strings.error}: $error',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final Map<String, List<ChatThread>> grouped;
  final String? activeThreadId;
  final ValueChanged<String> onSelectThread;

  const _HistoryList({
    required this.grouped,
    required this.activeThreadId,
    required this.onSelectThread,
  });

  @override
  Widget build(BuildContext context) {
    // Use Uzbek Cyrillic as default for static section headers on history screen.
    final strings = AppStrings(AppLanguage.uzbekCyrillic);
    final List<Widget> children = [];

    void addSection(String key, String title) {
      final threads = grouped[key] ?? const [];
      if (threads.isEmpty) return;

      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      for (final thread in threads) {
        children.add(
          _HistoryItem(
            thread: thread,
            isActive: thread.id == activeThreadId,
            onTap: () => onSelectThread(thread.id),
          ),
        );
      }
    }

    // Map our groups to sections similar to Today / Yesterday
    addSection('today', strings.today);
    addSection('thisWeek', strings.thisWeek);
    addSection('older', strings.older);

    if (children.isEmpty) {
      return Center(
        child: Text(
          strings.noChats,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: children,
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final ChatThread thread;
  final bool isActive;
  final VoidCallback onTap;

  const _HistoryItem({
    required this.thread,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isActive ? AppColors.accent : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            thread.title,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
