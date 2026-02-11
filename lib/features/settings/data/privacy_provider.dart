import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import 'privacy_service.dart';

/// Provider for privacy policy content
/// Fetches content from GitHub based on current language
final privacyContentProvider = FutureProvider<String?>((ref) async {
  final currentLanguage = ref.watch(languageProvider);
  final languageCode = currentLanguage.code;
  
  return await PrivacyService.fetchPrivacyWithFallback(languageCode);
});
