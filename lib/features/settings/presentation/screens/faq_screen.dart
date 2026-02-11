import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/faq_provider.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    // First item is expanded by default
    _expandedIndex = 0;
  }

  List<Map<String, String>> _parseFaqContent(String content) {
    final List<Map<String, String>> faqs = [];
    final lines = content.split('\n');
    
    String? currentQuestion;
    StringBuffer currentAnswer = StringBuffer();
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      // Check if line is an H2 heading (## number. question)
      if (line.startsWith('## ')) {
        // Save previous FAQ if exists
        if (currentQuestion != null) {
          faqs.add({
            'question': currentQuestion,
            'answer': currentAnswer.toString().trim(),
          });
          currentAnswer.clear();
        }
        
        // Extract question (remove ## and number prefix)
        currentQuestion = line.substring(3).trim();
        // Remove leading number and dot if present (e.g., "1. Question" -> "Question")
        final numberMatch = RegExp(r'^\d+\.\s*').firstMatch(currentQuestion);
        if (numberMatch != null) {
          currentQuestion = currentQuestion.substring(numberMatch.end).trim();
        }
      } else if (currentQuestion != null && line.isNotEmpty) {
        // Add to answer (skip H1 and italic lines at the start)
        if (!line.startsWith('#') && !line.startsWith('_')) {
          if (currentAnswer.length > 0) {
            currentAnswer.write('\n');
          }
          currentAnswer.write(line);
        }
      }
    }
    
    // Add last FAQ
    if (currentQuestion != null) {
      faqs.add({
        'question': currentQuestion,
        'answer': currentAnswer.toString().trim(),
      });
    }
    
    return faqs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                color: AppColors.cardBackground,
                child: ref.watch(faqContentProvider).when(
                  data: (content) {
                    if (content == null || content.isEmpty) {
                      return _buildErrorState(ref);
                    }
                    final faqs = _parseFaqContent(content);
                    return SingleChildScrollView(
                      padding: AppSpacing.paddingXl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            faqs.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.s),
                              child: _buildFaqItem(index, faqs[index]),
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

  Widget _buildHeader(BuildContext context) {
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
              ref.watch(stringsProvider).faq,
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
              'Loading FAQ...',
              style: const TextStyle(
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

  Widget _buildFaqItem(int index, Map<String, String> faq) {
    final isExpanded = _expandedIndex == index;

    return Container(
      padding: AppSpacing.paddingM,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.borderRadiusS,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isExpanded && faq['answer']!.isNotEmpty) ...[
                  AppSpacing.gapVerticalS,
                  Text(
                    faq['answer']!,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.gapHorizontalM,
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: Container(
              padding: AppSpacing.paddingS,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                border: Border.all(color: AppColors.accent.withOpacity(0.16)),
                borderRadius: AppSpacing.borderRadiusS,
              ),
              child: Icon(
                isExpanded
                    ? PhosphorIconsRegular.caretUp
                    : PhosphorIconsRegular.caretDown,
                size: AppSpacing.xl,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
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
              'Failed to load FAQ',
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
                ref.invalidate(faqContentProvider);
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
