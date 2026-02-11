import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../data/privacy_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final privacyAsyncValue = ref.watch(privacyContentProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, strings),
            // Content
            Expanded(
              child: privacyAsyncValue.when(
                data: (content) => content != null && content.isNotEmpty
                    ? _buildContent(content)
                    : _buildEmptyState(strings),
                loading: () => _buildLoadingState(),
                error: (error, stack) => _buildErrorState(strings, error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings) {
    return SizedBox(
      height: SpacingTokens.spacing60,
      child: Padding(
        padding: SpacingTokens.horizontalPadding20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
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
            ),
            Text(
              strings.privacyPolicy,
              style: AppTypography.headline4.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String markdownContent) {
    return SingleChildScrollView(
      padding: SpacingTokens.padding20,
      child: Container(
        constraints: const BoxConstraints(maxWidth: SpacingTokens.maxContentWidth),
        padding: SpacingTokens.padding20,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: SpacingTokens.borderRadius14,
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        child: Markdown(
          data: markdownContent,
          selectable: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          styleSheet: MarkdownStyleSheet(
            h1: AppTypography.headline3.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            h2: AppTypography.headline4.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            h3: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            p: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            listBullet: AppTypography.bodyMedium.copyWith(
              color: AppColors.accent,
            ),
            blockSpacing: SpacingTokens.spacing12,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.accent,
          ),
          SpacingTokens.verticalGap16,
          Text(
            'Loading Privacy Policy...',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppStrings strings, String error) {
    return Center(
      child: Padding(
        padding: SpacingTokens.padding20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.warningCircle,
              size: 64,
              color: AppColors.error,
            ),
            SpacingTokens.verticalGap16,
            Text(
              'Error loading Privacy Policy',
              style: AppTypography.headline4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SpacingTokens.verticalGap8,
            Text(
              error,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
            PhosphorIconsRegular.shieldCheckered,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          SpacingTokens.verticalGap16,
          Text(
            'No Privacy Policy available',
            style: AppTypography.headline4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
