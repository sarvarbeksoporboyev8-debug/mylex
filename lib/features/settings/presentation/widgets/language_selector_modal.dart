import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/app_strings.dart';

/// A reusable language selector modal for settings screens.
/// 
/// This widget displays a bottom sheet with a list of available languages,
/// allowing users to select their preferred language.
class LanguageSelectorModal extends ConsumerWidget {
  /// Current selected language
  final AppLanguage currentLanguage;
  
  /// Localized strings
  final AppStrings strings;
  
  /// Row height
  final double rowHeight;
  
  /// Title font size
  final double titleFontSize;
  
  /// Row font size
  final double fontSize;
  
  /// Horizontal padding
  final double horizontalPadding;
  
  /// Icon-text gap
  final double iconTextGap;

  const LanguageSelectorModal({
    super.key,
    required this.currentLanguage,
    required this.strings,
    this.rowHeight = 52.0,
    this.titleFontSize = 18.0,
    this.fontSize = 14.0,
    this.horizontalPadding = 20.0,
    this.iconTextGap = 8.0,
  });

  /// Shows the language selector modal
  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required AppStrings strings,
    required AppLanguage currentLanguage,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFDFCF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => LanguageSelectorModal(
        currentLanguage: currentLanguage,
        strings: strings,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      child: SizedBox(
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
                      style: TextStyle(
                        fontSize: titleFontSize,
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
          const SizedBox(height: 8),
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
                      height: rowHeight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row(
                          children: [
                            Text(
                              _getLanguageFlag(language),
                              style: const TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: iconTextGap),
                            Expanded(
                              child: Text(
                                language.nativeName,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
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
                    margin: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                    ),
                    height: 0.5,
                    color: AppColors.divider,
                  ),
              ],
            );
          }),
          const SizedBox(height: 16),
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
