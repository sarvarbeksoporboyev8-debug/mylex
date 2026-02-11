import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/content_webview.dart';
import '../../data/codes_repository.dart';

class CodeDetailsScreen extends ConsumerWidget {
  final String id;

  const CodeDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeAsync = ref.watch(codeDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: codeAsync.when(
        data: (code) {
          if (code == null) {
            return Center(
              child: EmptyState.error(
                message: 'Кодекс топилмади',
                onRetry: () => context.pop(),
              ),
            );
          }

          final url = code.docUrl ?? 'https://lex.uz';

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
                          code.title,
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
          onRetry: () => ref.invalidate(codeDetailProvider(id)),
        ),
      ),
    );
  }
}
