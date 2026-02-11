import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch codes data from GitHub (pre-fetched from lex.uz)
class CodesService {
  static const Duration _timeout = Duration(seconds: 30);
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev8-debug/mylex-news-data/main/data';

  static const Map<String, String> _langFiles = {
    'uz-Cyrl': 'codes_uz_Cyrl.json',
    'uz': 'codes_uz.json',
    'ru': 'codes_ru.json',
    'en': 'codes_en.json',
  };

  /// Fetch codes for a single language
  static Future<List<Map<String, dynamic>>> fetchCodes(String languageCode) async {
    final file = _langFiles[languageCode] ?? 'codes_uz_Cyrl.json';
    final url = '$_baseUrl/$file';

    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      print('CodesService: Failed to fetch $languageCode: $e');
    }
    return [];
  }
}
