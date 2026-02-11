import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch terms and conditions content from GitHub
class TermsService {
  static const Duration _timeout = Duration(seconds: 30);
  
  // Base URL for terms content from GitHub repo
  // Files are in the root of the repository
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev-cmd/yuristai/main';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'terms_uz_cyrl.md',
    'uz': 'terms_uz.md',
    'ru': 'terms_ru.md',
    'en': 'terms_en.md',
  };

  /// Fetch terms content for a specific language
  /// Returns the raw text content (markdown or plain text)
  static Future<String?> fetchTerms(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'terms_en.md';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('TermsService: Failed to fetch terms for $languageCode: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('TermsService: Error fetching terms for $languageCode: $e');
      return null;
    }
  }

  /// Fetch terms content with fallback to English if language-specific version fails
  static Future<String?> fetchTermsWithFallback(String languageCode) async {
    final content = await fetchTerms(languageCode);
    if (content != null && content.isNotEmpty) {
      return content;
    }
    
    // Fallback to English
    if (languageCode != 'en') {
      print('TermsService: Falling back to English for $languageCode');
      return await fetchTerms('en');
    }
    
    return null;
  }
}
