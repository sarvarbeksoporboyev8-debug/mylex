import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - h-[60px], pb-[12px] pt-[8px] px-[20px]
            _buildHeader(context),
            // Content - white background, p-[20px]
            Expanded(
              child: Container(
                color: Colors.white,
                child: ref.watch(faqContentProvider).when(
                  data: (content) {
                    if (content == null || content.isEmpty) {
                      return _buildErrorState(ref);
                    }
                    final faqs = _parseFaqContent(content);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            faqs.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
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
              ref.watch(stringsProvider).faq,
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

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading FAQ...',
              style: TextStyle(
                fontFamily: 'Onest',
                fontSize: 14,
                color: Color(0xFF606060),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(int index, Map<String, String> faq) {
    final isExpanded = _expandedIndex == index;

    // bg-white, gap-[12px], p-[12px], gap-[8px] between question and answer
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question - font-['Onest:Medium'], text-[16px], leading-[1.5]
                Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF101010),
                  ),
                ),
                if (isExpanded && faq['answer']!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Answer - font-['Onest:Regular'], text-[16px], leading-[1.5]
                  Text(
                    faq['answer']!,
                    style: const TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: Color(0xFF606060),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Icon button - bg-[#f2eef9], border border-[#f2e6ff], p-[8px]
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                border: Border.all(color: AppColors.accent.withOpacity(0.16)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isExpanded
                    ? PhosphorIconsRegular.caretUp
                    : PhosphorIconsRegular.caretDown,
                size: 20,
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
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Color(0xFF606060),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load FAQ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Onest',
                fontSize: 14,
                color: Color(0xFF606060),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(faqContentProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
