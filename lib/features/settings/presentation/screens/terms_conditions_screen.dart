import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/terms_provider.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref),
            Expanded(
              child: Container(
                color: AppColors.cardBackground,
                child: ref.watch(termsContentProvider).when(
                  data: (content) {
                    if (content == null || content.isEmpty) {
                      return _buildErrorState(ref);
                    }
                    return SingleChildScrollView(
                      padding: AppSpacing.paddingXl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: content,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                              h1: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textPrimary,
                              ),
                              h2: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textPrimary,
                              ),
                              h3: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textPrimary,
                              ),
                              strong: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              listBullet: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    );
                  },
                  loading: () => _buildLoadingState(),
                  error: (error, stack) => _buildErrorState(ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    return SizedBox(
      height: 60,
      child: Padding(
        padding: AppSpacing.screenPaddingHorizontal,
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
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppSpacing.borderRadiusS,
                    color: AppColors.cardBackground,
                  ),
                  child: Icon(
                    PhosphorIconsRegular.caretLeft,
                    size: AppSpacing.xl,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Text(
              strings.termsAndConditions,
              style: const TextStyle(
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl + AppSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            AppSpacing.gapVerticalL,
            Text(
              'Loading terms and conditions...',
              style: TextStyle(
                fontFamily: 'Onest',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl + AppSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.textSecondary,
            ),
            AppSpacing.gapVerticalL,
            Text(
              'Failed to load terms and conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Onest',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.gapVerticalXl,
            ElevatedButton(
              onPressed: () {
                ref.invalidate(termsContentProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textOnAccent,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.m),
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusS,
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Onest',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
