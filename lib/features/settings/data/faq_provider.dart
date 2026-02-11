import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import 'faq_service.dart';

/// Provider for FAQ content
/// Fetches content from GitHub based on current language
final faqContentProvider = FutureProvider<String?>((ref) async {
  final currentLanguage = ref.watch(languageProvider);
  final languageCode = currentLanguage.code;
  
  return await FaqService.fetchFaqWithFallback(languageCode);
});
