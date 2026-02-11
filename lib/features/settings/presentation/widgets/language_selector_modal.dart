import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';

/// Language selector modal bottom sheet
class LanguageSelectorModal extends ConsumerWidget {
  const LanguageSelectorModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final currentLanguage = ref.watch(languageProvider);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SpacingTokens.radius20),
          topRight: Radius.circular(SpacingTokens.radius20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: SpacingTokens.spacing12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            SpacingTokens.gapV20,
            
            // Title
            Padding(
              padding: SpacingTokens.paddingHorizontal20,
              child: Text(
                strings.language,
                style: AppTypography.titleMedium.copyWith(
                  color: const Color(0xFF101010),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            SpacingTokens.gapV16,
            
            // Language options
            ...AppLanguage.values.map((language) {
              final isSelected = currentLanguage == language;
              return _LanguageOption(
                language: language,
                isSelected: isSelected,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage(language);
                  Navigator.of(context).pop();
                },
              );
            }),
            
            SpacingTokens.gapV16,
          ],
        ),
      ),
    );
  }

  /// Show the language selector modal
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageSelectorModal(),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  String get _languageName {
    switch (language) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.ru:
        return 'Русский';
      case AppLanguage.uz:
        return 'O'zbekcha';
      case AppLanguage.uzCyrl:
        return 'Ўзбекча';
    }
  }

  String get _languageCode {
    switch (language) {
      case AppLanguage.en:
        return 'EN';
      case AppLanguage.ru:
        return 'RU';
      case AppLanguage.uz:
        return 'UZ';
      case AppLanguage.uzCyrl:
        return 'UZ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing20,
          vertical: SpacingTokens.spacing16,
        ),
        child: Row(
          children: [
            // Language flag/icon (you can replace with actual flag images)
            Container(
              width: SpacingTokens.spacing40,
              height: SpacingTokens.spacing40,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.accent.withOpacity(0.1)
                    : const Color(0xFFF5F5F5),
                borderRadius: SpacingTokens.borderRadius8,
              ),
              child: Center(
                child: Text(
                  _languageCode,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.accent : const Color(0xFF606060),
                  ),
                ),
              ),
            ),
            
            SpacingTokens.gapH12,
            
            // Language name
            Expanded(
              child: Text(
                _languageName,
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF101010),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
