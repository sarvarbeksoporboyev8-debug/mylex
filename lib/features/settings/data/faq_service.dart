import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch FAQ content from GitHub
class FaqService {
  static const Duration _timeout = Duration(seconds: 30);
  
  // Base URL for FAQ content from GitHub repo
  // Files are in the root of the repository
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev-cmd/yuristai/main';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'faq_uz_cyrl.md',
    'uz': 'faq_uz.md',
    'ru': 'faq_ru.md',
    'en': 'faq_en.md',
  };

  /// Fetch FAQ content for a specific language
  /// Returns the raw text content (markdown or plain text)
  static Future<String?> fetchFaq(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'faq_en.md';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('FaqService: Failed to fetch FAQ for $languageCode: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('FaqService: Error fetching FAQ for $languageCode: $e');
      return null;
    }
  }

  /// Fetch FAQ content with fallback to English if language-specific version fails
  static Future<String?> fetchFaqWithFallback(String languageCode) async {
    final content = await fetchFaq(languageCode);
    if (content != null && content.isNotEmpty) {
      return content;
    }
    
    // Fallback to English
    if (languageCode != 'en') {
      print('FaqService: Falling back to English for $languageCode');
      return await fetchFaq('en');
    }
    
    return null;
  }
}
