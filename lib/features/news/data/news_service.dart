import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch news data from GitHub (pre-fetched from lex.uz)
class NewsService {
  static const Duration _timeout = Duration(seconds: 30);
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev8-debug/mylex-news-data/main/data';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'news_uz_Cyrl.json',
    'uz': 'news_uz.json',
    'ru': 'news_ru.json',
    'en': 'news_en.json',
  };

  /// Fetch news for a single language
  static Future<List<Map<String, dynamic>>> fetchNews(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'news_uz_Cyrl.json';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('NewsService: Failed to fetch $languageCode: $e');
    }
    return [];
  }
}
