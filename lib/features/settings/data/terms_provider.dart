import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import 'terms_service.dart';

/// Provider for terms and conditions content
/// Fetches content from GitHub based on current language
final termsContentProvider = FutureProvider<String?>((ref) async {
  final currentLanguage = ref.watch(languageProvider);
  final languageCode = currentLanguage.code;
  
  return await TermsService.fetchTermsWithFallback(languageCode);
});
