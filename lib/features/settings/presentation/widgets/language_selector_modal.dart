import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/models/settings_models.dart';

/// Language selector modal bottom sheet
/// 
/// Displays a list of available languages for selection
class LanguageSelectorModal extends StatelessWidget {
  final String currentLanguage;
  final List<LanguageOption> languages;
  final Function(String) onLanguageSelected;

  const LanguageSelectorModal({
    super.key,
    required this.currentLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SpacingTokens.spacing20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: SpacingTokens.verticalPadding8,
            width: SpacingTokens.spacing40,
            height: SpacingTokens.spacing4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.3),
              borderRadius: SpacingTokens.borderRadiusFull,
            ),
          ),
          // Title
          Padding(
            padding: SpacingTokens.padding20,
            child: Text(
              'Select Language',
              style: AppTypography.headline4.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Language list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: languages.length,
            separatorBuilder: (context, index) => Padding(
              padding: SpacingTokens.horizontalPadding20,
              child: const Divider(height: 1, thickness: 0.5),
            ),
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language.code == currentLanguage;
              
              return InkWell(
                onTap: () {
                  onLanguageSelected(language.code);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SpacingTokens.spacing20,
                    vertical: SpacingTokens.spacing16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        language.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      SpacingTokens.horizontalGap12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              language.name,
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (language.nativeName != null) ...[
                              SpacingTokens.verticalGap2,
                              Text(
                                language.nativeName!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          PhosphorIconsFill.checkCircle,
                          color: AppColors.accent,
                          size: SpacingTokens.iconSize24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + SpacingTokens.spacing16),
        ],
      ),
    );
  }

  /// Show the language selector modal
  static Future<void> show(
    BuildContext context, {
    required String currentLanguage,
    required List<LanguageOption> languages,
    required Function(String) onLanguageSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LanguageSelectorModal(
        currentLanguage: currentLanguage,
        languages: languages,
        onLanguageSelected: onLanguageSelected,
      ),
    );
  }
}
