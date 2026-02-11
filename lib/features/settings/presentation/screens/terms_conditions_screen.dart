import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_strings.dart';
import '../../data/terms_provider.dart';
import '../widgets/settings_widgets.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SettingsScreenHeader(
              title: ref.watch(stringsProvider).termsAndConditions,
            ),
            // Content - white background, p-[20px]
            Expanded(
              child: Container(
                color: Colors.white,
                child: ref.watch(termsContentProvider).when(
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

  Widget _buildHeaderCard(WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        color: AppColors.accent.withOpacity(0.08),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // decorative blobs
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // actual content - centered
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Onest',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.5,
                        color: Color(0xFF101010),
                      ),
                      children: const [
                        TextSpan(text: 'Tabssi '),
                        // The actual "Terms & Conditions" text is in the header title;
                        // keeping this static to avoid non-const issues inside const TextSpan.
                        TextSpan(
                          text: 'Term & Condition',
                          style: TextStyle(color: AppColors.accent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Last Updated: May 15, 2025',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF383838),
                    ),
                  ),
                ],
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
              'Loading terms and conditions...',
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
              'Failed to load terms and conditions',
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
                ref.invalidate(termsContentProvider);
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
