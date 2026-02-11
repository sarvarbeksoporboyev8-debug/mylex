import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/privacy_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - h-[60px], pb-[12px] pt-[8px] px-[20px]
            _buildHeader(context, ref),
            // Content - white background, p-[20px]
            Expanded(
              child: Container(
                color: Colors.white,
                child: ref.watch(privacyContentProvider).when(
                  data: (content) {
                    if (content == null || content.isEmpty) {
                      return _buildErrorState(ref);
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
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
                                color: Color(0xFF606060),
                              ),
                              h1: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF101010),
                              ),
                              h2: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF101010),
                              ),
                              h3: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF101010),
                              ),
                              strong: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF101010),
                              ),
                              listBullet: const TextStyle(
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.5,
                                color: Color(0xFF606060),
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
              strings.privacyPolicy,
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
              'Loading privacy policy...',
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
              'Failed to load privacy policy',
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
                ref.invalidate(privacyContentProvider);
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
