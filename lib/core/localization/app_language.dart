import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the app
enum AppLanguage {
  uzbekCyrillic('uz-Cyrl', 'Ўзбек (Кирилл)', 'Uzbek (Cyrillic)'),
  uzbekLatin('uz', "O'zbek (Lotin)", 'Uzbek (Latin)'),
  russian('ru', 'Русский', 'Russian'),
  english('en', 'English', 'English');

  final String code;
  final String nativeName;
  final String englishName;

  const AppLanguage(this.code, this.nativeName, this.englishName);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.uzbekCyrillic,
    );
  }
}

/// Language state notifier
class LanguageNotifier extends StateNotifier<AppLanguage> {
  static const _key = 'app_language';

  LanguageNotifier() : super(AppLanguage.uzbekCyrillic) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = AppLanguage.fromCode(code);
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, language.code);
  }
}

/// Provider for current language
final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>(
  (ref) => LanguageNotifier(),
);
