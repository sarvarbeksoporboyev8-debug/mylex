import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch laws data from GitHub (pre-fetched from lex.uz)
class LawsService {
  static const Duration _timeout = Duration(seconds: 30);
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev8-debug/mylex-news-data/main/data';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'laws_uz_Cyrl.json',
    'uz': 'laws_uz.json',
    'ru': 'laws_ru.json',
    'en': 'laws_en.json',
  };

  /// Fetch laws for a single language
  static Future<List<Map<String, dynamic>>> fetchLaws(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'laws_uz_Cyrl.json';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('LawsService: Failed to fetch $languageCode: $e');
    }
    return [];
  }
}
