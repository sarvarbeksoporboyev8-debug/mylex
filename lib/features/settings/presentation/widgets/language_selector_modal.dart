import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';

/// A reusable language selector modal bottom sheet.
/// Displays available languages with flags and allows selection.
class LanguageSelectorModal extends ConsumerWidget {
  final AppLanguage currentLanguage;

  const LanguageSelectorModal({
    super.key,
    required this.currentLanguage,
  });

  /// Show the language selector modal
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
    AppLanguage currentLanguage,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFDFCF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SpacingTokens.spacing16),
        ),
      ),
      builder: (ctx) => LanguageSelectorModal(currentLanguage: currentLanguage),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          SizedBox(
            height: 56,
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: const SizedBox(
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
                Expanded(
                  child: Center(
                    child: Text(
                      strings.languageLabel,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 56),
              ],
            ),
          ),
          Container(height: 0.5, color: AppColors.divider),
          SpacingTokens.gapV8,
          // Language options
          ...AppLanguage.values.asMap().entries.map((entry) {
            final index = entry.key;
            final language = entry.value;
            final isSelected = language == currentLanguage;
            final isLast = index == AppLanguage.values.length - 1;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(languageProvider.notifier).setLanguage(language);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      height: 52.0,
                      child: Padding(
                        padding: SpacingTokens.paddingHorizontal20,
                        child: Row(
                          children: [
                            Text(
                              _getLanguageFlag(language),
                              style: const TextStyle(fontSize: 20),
                            ),
                            SpacingTokens.gapH8,
                            Expanded(
                              child: Text(
                                language.nativeName,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                PhosphorIconsRegular.check,
                                size: 20,
                                color: AppColors.accent,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.only(
                      left: SpacingTokens.spacing16,
                      right: SpacingTokens.spacing16,
                    ),
                    height: 0.5,
                    color: AppColors.divider,
                  ),
              ],
            );
          }),
          SpacingTokens.gapV16,
        ],
      ),
    );
  }

  String _getLanguageFlag(AppLanguage language) {
    switch (language) {
      case AppLanguage.uzbekCyrillic:
      case AppLanguage.uzbekLatin:
        return '🇺🇿';
      case AppLanguage.russian:
        return '🇷🇺';
      case AppLanguage.english:
        return '🇬🇧';
    }
  }
}
