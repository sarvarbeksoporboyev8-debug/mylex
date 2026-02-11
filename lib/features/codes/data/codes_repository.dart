import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/code_model.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/services/metadata_service.dart';
import 'codes_service.dart';

/// Global cache for all languages - shared across repository instances
class CodesCache {
  static const String _storageKey = 'codes_cache';
  static Map<String, List<CodeDocument>>? _cache;
  static bool _isLoading = false;

  static Map<String, List<CodeDocument>>? get cache => _cache;
  static bool get isLoading => _isLoading;

  static void setCache(Map<String, List<CodeDocument>> data) {
    _cache = data;
  }

  static void clear() {
    _cache = null;
  }

  static void setLoading(bool loading) {
    _isLoading = loading;
  }

  /// Save cache to local storage
  static Future<void> saveToStorage() async {
    if (_cache == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = <String, List<Map<String, dynamic>>>{};
      for (final entry in _cache!.entries) {
        data[entry.key] = entry.value.map((c) => {
          'id': c.id,
          'title': c.title,
          'url': c.docUrl,
        }).toList();
      }
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      print('CodesCache: Failed to save to storage: $e');
    }
  }

  /// Load cache from local storage
  static Future<Map<String, List<Map<String, dynamic>>>?> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey);
      if (stored != null) {
        final decoded = jsonDecode(stored) as Map<String, dynamic>;
        final result = <String, List<Map<String, dynamic>>>{};
        for (final entry in decoded.entries) {
          result[entry.key] = (entry.value as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        return result;
      }
    } catch (e) {
      print('CodesCache: Failed to load from storage: $e');
    }
    return null;
  }
}

/// Repository for codes data - online first, cached for offline
class CodesRepository {
  final String languageCode;
  
  CodesRepository({required this.languageCode});

  /// Clear cache to force refresh (clears ALL languages)
  void clearCache() {
    CodesCache.clear();
  }

  /// Get issuer text for language
  String _getIssuer(String lang) {
    switch (lang) {
      case 'uz':
        return "O'zbekiston Respublikasi Oliy Majlisi";
      case 'ru':
        return "Олий Мажлис Республики Узбекистан";
      case 'en':
        return "Oliy Majlis of the Republic of Uzbekistan";
      default:
        return "Ўзбекистон Республикаси Олий Мажлиси";
    }
  }

  /// Convert remote/stored data to CodeDocument list
  List<CodeDocument> _convertData(List<Map<String, dynamic>> data, String lang) {
    return data.asMap().entries.map((entry) {
      // Try to parse date from API, fallback to null (will show no date)
      DateTime? docDate;
      if (entry.value['date'] != null) {
        try {
          docDate = DateTime.parse(entry.value['date'].toString());
        } catch (_) {}
      }
      
      return CodeDocument(
        id: entry.value['id'] ?? '',
        index: entry.key + 1,
        title: entry.value['title'] ?? '',
        issuer: _getIssuer(lang),
        docNumber: entry.value['id'] ?? '',
        date: docDate,
        summary: '',
        content: '',
        pdfUrl: (entry.value['url'] ?? '').replaceAll('/docs/', '/pdfs/'),
        docUrl: entry.value['url'] ?? '',
      );
    }).toList();
  }

  /// Load codes for current language only
  Future<void> _loadData() async {
    // Wait if already loading
    while (CodesCache.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    // If cache has data for current language, check if update needed
    if (CodesCache.cache != null && 
        CodesCache.cache![languageCode] != null &&
        CodesCache.cache![languageCode]!.isNotEmpty) {
      // Check for updates in background, don't block
      _checkAndUpdateInBackground();
      return;
    }
    
    CodesCache.setLoading(true);

    try {
      // First, load from local storage (for immediate display)
      final storedData = await CodesCache.loadFromStorage();
      
      if (storedData != null && storedData[languageCode] != null) {
        final cache = CodesCache.cache ?? <String, List<CodeDocument>>{};
        cache[languageCode] = _convertData(storedData[languageCode]!, languageCode);
        CodesCache.setCache(cache);
      }

      // Check if we need to fetch new data
      final hasUpdates = await MetadataService.hasUpdates();
      final cacheEmpty = CodesCache.cache == null || 
                         CodesCache.cache![languageCode] == null || 
                         CodesCache.cache![languageCode]!.isEmpty;
      
      if (hasUpdates || cacheEmpty) {
        final remoteData = await CodesService.fetchCodes(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = CodesCache.cache ?? <String, List<CodeDocument>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          CodesCache.setCache(cache);
          await CodesCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('CodesRepository: Failed to load: $e');
    } finally {
      CodesCache.setLoading(false);
    }
  }

  /// Check for updates in background without blocking UI
  Future<void> _checkAndUpdateInBackground() async {
    try {
      final hasUpdates = await MetadataService.hasUpdates();
      if (hasUpdates) {
        final remoteData = await CodesService.fetchCodes(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = CodesCache.cache ?? <String, List<CodeDocument>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          CodesCache.setCache(cache);
          await CodesCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('CodesRepository: Background update failed: $e');
    }
  }

  Future<List<CodeDocument>> getCodes({
    CodeFilter filter = CodeFilter.all,
    String? searchQuery,
  }) async {
    // Load if cache is empty for current language
    if (CodesCache.cache == null || 
        CodesCache.cache?[languageCode] == null ||
        CodesCache.cache![languageCode]!.isEmpty) {
      await _loadData();
    }

    var codes = List<CodeDocument>.from(CodesCache.cache?[languageCode] ?? []);

    // Apply filter
    switch (filter) {
      case CodeFilter.favorites:
        codes = codes.where((c) => c.isFavorite).toList();
        break;
      case CodeFilter.downloaded:
        codes = codes.where((c) => c.isDownloaded).toList();
        break;
      case CodeFilter.all:
        break;
    }

    // Apply search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      codes = codes.where((c) => c.title.toLowerCase().contains(query)).toList();
    }

    return codes;
  }

  Future<CodeDocument?> getCodeById(String id) async {
    if (CodesCache.cache == null || CodesCache.cache?[languageCode]?.isEmpty == true) {
      await _loadData();
    }
    try {
      return CodesCache.cache?[languageCode]?.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleFavorite(String id) async {}
  Future<void> downloadCode(String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

/// Provider for codes repository - depends on language
final codesRepositoryProvider = Provider<CodesRepository>((ref) {
  final language = ref.watch(languageProvider);
  return CodesRepository(languageCode: language.code);
});

/// Provider for codes list
final codesListProvider = FutureProvider.autoDispose.family<List<CodeDocument>, ({CodeFilter filter, String? query})>(
  (ref, params) async {
    final repository = ref.watch(codesRepositoryProvider);
    return repository.getCodes(filter: params.filter, searchQuery: params.query);
  },
);

/// Provider for single code
final codeDetailProvider = FutureProvider.family<CodeDocument?, String>(
  (ref, id) async {
    final repository = ref.watch(codesRepositoryProvider);
    return repository.getCodeById(id);
  },
);
