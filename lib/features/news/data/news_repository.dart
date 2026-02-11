import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/news_model.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/services/metadata_service.dart';
import 'news_service.dart';

/// Global cache for all languages - shared across repository instances
class NewsCache {
  static const String _storageKey = 'news_cache';
  static Map<String, List<NewsArticle>>? _cache;
  static bool _isLoading = false;

  static Map<String, List<NewsArticle>>? get cache => _cache;
  static bool get isLoading => _isLoading;

  static void setCache(Map<String, List<NewsArticle>> data) {
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
        data[entry.key] = entry.value.map((n) => {
          'id': n.id,
          'title': n.title,
          'url': n.docUrl,
        }).toList();
      }
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      print('NewsCache: Failed to save to storage: $e');
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
      print('NewsCache: Failed to load from storage: $e');
    }
    return null;
  }
}

/// Repository for news data - online first, cached for offline
class NewsRepository {
  final String languageCode;
  
  NewsRepository({required this.languageCode});

  /// Clear cache to force refresh (clears ALL languages)
  void clearCache() {
    NewsCache.clear();
  }

  /// Get category label for language
  String _getCategory(String lang) {
    switch (lang) {
      case 'uz':
        return 'Qonunchilik';
      case 'ru':
        return 'Законодательство';
      case 'en':
        return 'Legislation';
      default:
        return 'Қонунчилик';
    }
  }

  /// Convert remote/stored data to NewsArticle list
  List<NewsArticle> _convertData(List<Map<String, dynamic>> data, String lang) {
    return data.asMap().entries.map((entry) => NewsArticle(
      id: entry.value['id'] ?? '',
      title: entry.value['title'] ?? '',
      summary: null,
      content: '',
      date: DateTime.now().subtract(Duration(hours: entry.key)),
      category: _getCategory(lang),
      pdfUrl: (entry.value['url'] ?? '').replaceAll('/docs/', '/pdfs/'),
      docUrl: entry.value['url'] ?? '',
    )).toList();
  }

  /// Load news for current language only
  Future<void> _loadData() async {
    // Wait if already loading
    while (NewsCache.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    // If cache has data for current language, check if update needed
    if (NewsCache.cache != null && 
        NewsCache.cache![languageCode] != null &&
        NewsCache.cache![languageCode]!.isNotEmpty) {
      _checkAndUpdateInBackground();
      return;
    }
    
    NewsCache.setLoading(true);

    try {
      // First, load from local storage
      final storedData = await NewsCache.loadFromStorage();
      
      if (storedData != null && storedData[languageCode] != null) {
        final cache = NewsCache.cache ?? <String, List<NewsArticle>>{};
        cache[languageCode] = _convertData(storedData[languageCode]!, languageCode);
        NewsCache.setCache(cache);
      }

      // Check if we need to fetch new data
      final hasUpdates = await MetadataService.hasUpdates();
      final cacheEmpty = NewsCache.cache == null || 
                         NewsCache.cache![languageCode] == null || 
                         NewsCache.cache![languageCode]!.isEmpty;
      
      if (hasUpdates || cacheEmpty) {
        final remoteData = await NewsService.fetchNews(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = NewsCache.cache ?? <String, List<NewsArticle>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          NewsCache.setCache(cache);
          await NewsCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('NewsRepository: Failed to load: $e');
    } finally {
      NewsCache.setLoading(false);
    }
  }

  /// Check for updates in background without blocking UI
  Future<void> _checkAndUpdateInBackground() async {
    try {
      final hasUpdates = await MetadataService.hasUpdates();
      if (hasUpdates) {
        final remoteData = await NewsService.fetchNews(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = NewsCache.cache ?? <String, List<NewsArticle>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          NewsCache.setCache(cache);
          await NewsCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('NewsRepository: Background update failed: $e');
    }
  }

  Future<List<NewsArticle>> getNews({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    // Load if cache is empty for current language
    if (NewsCache.cache == null || 
        NewsCache.cache?[languageCode] == null ||
        NewsCache.cache![languageCode]!.isEmpty) {
      await _loadData();
    }

    var news = List<NewsArticle>.from(NewsCache.cache?[languageCode] ?? []);

    // Apply category filter
    if (category != null && category.isNotEmpty) {
      news = news.where((n) => n.category == category).toList();
    }

    // Apply search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      news = news.where((n) => n.title.toLowerCase().contains(query)).toList();
    }

    // Apply pagination
    if (offset != null && limit != null) {
      final end = (offset + limit).clamp(0, news.length);
      news = news.sublist(offset.clamp(0, news.length), end);
    }

    return news;
  }

  Future<NewsArticle?> getNewsById(String id) async {
    if (NewsCache.cache == null || NewsCache.cache?[languageCode]?.isEmpty == true) {
      await _loadData();
    }
    try {
      return NewsCache.cache?[languageCode]?.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  List<String> getCategories() {
    switch (languageCode) {
      case 'uz':
        return ['Qonunchilik', 'Soliq', 'Huquq', 'Raqamlashtirish'];
      case 'ru':
        return ['Законодательство', 'Налоги', 'Право', 'Цифровизация'];
      case 'en':
        return ['Legislation', 'Tax', 'Law', 'Digitalization'];
      default:
        return ['Қонунчилик', 'Солиқ', 'Ҳуқуқ', 'Рақамлаштириш'];
    }
  }
}

/// Provider for news repository - depends on language
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final language = ref.watch(languageProvider);
  return NewsRepository(languageCode: language.code);
});

/// Provider for news list
final newsListProvider = FutureProvider.autoDispose.family<List<NewsArticle>, String?>(
  (ref, searchQuery) async {
    final repository = ref.watch(newsRepositoryProvider);
    return repository.getNews(searchQuery: searchQuery);
  },
);

/// Provider for single news article
final newsDetailProvider = FutureProvider.family<NewsArticle?, String>(
  (ref, id) async {
    final repository = ref.watch(newsRepositoryProvider);
    return repository.getNewsById(id);
  },
);
