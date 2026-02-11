import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/content_webview.dart';
import '../../data/laws_repository.dart';

class LawDetailsScreen extends ConsumerWidget {
  final String id;

  const LawDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawAsync = ref.watch(lawDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: lawAsync.when(
        data: (law) {
          if (law == null) {
            return Center(
              child: EmptyState.error(
                message: 'Қонун топилмади',
                onRetry: () => context.pop(),
              ),
            );
          }

          final url = law.pdfUrl ?? law.docUrl ?? 'https://lex.uz';

          return SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    border: Border(
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: () => context.pop(),
                      ),
                      Expanded(
                        child: Text(
                          law.title,
                          style: AppTypography.titleSmall.copyWith(fontFamily: 'Roboto'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content WebView
                Expanded(
                  child: ContentWebView(url: url),
                ),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (error, stack) => EmptyState.error(
          message: error.toString(),
          onRetry: () => ref.invalidate(lawDetailProvider(id)),
        ),
      ),
    );
  }
}
