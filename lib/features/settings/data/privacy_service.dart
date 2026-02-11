import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch privacy policy content from GitHub
class PrivacyService {
  static const Duration _timeout = Duration(seconds: 30);
  
  // Base URL for privacy policy content from GitHub repo
  // Files are in the root of the repository
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev-cmd/yuristai/main';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'privacy_uz_cyrl.md',
    'uz': 'privacy_uz.md',
    'ru': 'privacy_ru.md',
    'en': 'privacy_en.md',
  };

  /// Fetch privacy policy content for a specific language
  /// Returns the raw text content (markdown or plain text)
  static Future<String?> fetchPrivacy(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'privacy_en.md';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('PrivacyService: Failed to fetch privacy for $languageCode: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('PrivacyService: Error fetching privacy for $languageCode: $e');
      return null;
    }
  }

  /// Fetch privacy policy content with fallback to English if language-specific version fails
  static Future<String?> fetchPrivacyWithFallback(String languageCode) async {
    final content = await fetchPrivacy(languageCode);
    if (content != null && content.isNotEmpty) {
      return content;
    }
    
    // Fallback to English
    if (languageCode != 'en') {
      print('PrivacyService: Falling back to English for $languageCode');
      return await fetchPrivacy('en');
    }
    
    return null;
  }
}
