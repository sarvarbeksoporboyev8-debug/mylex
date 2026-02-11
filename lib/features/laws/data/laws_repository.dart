import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/law_model.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/services/metadata_service.dart';
import 'laws_service.dart';

/// Global cache for all languages - shared across repository instances
class LawsCache {
  static const String _storageKey = 'laws_cache';
  static Map<String, List<LawDocument>>? _cache;
  static bool _isLoading = false;

  // Favorites stored in memory (would be persisted in real app)
  static final Set<String> _favorites = {};
  static final Set<String> _downloaded = {};

  static Map<String, List<LawDocument>>? get cache => _cache;
  static bool get isLoading => _isLoading;

  static void setCache(Map<String, List<LawDocument>> data) {
    _cache = data;
  }

  static void clear() {
    _cache = null;
  }

  static void setLoading(bool loading) {
    _isLoading = loading;
  }

  static Set<String> get favorites => _favorites;
  static Set<String> get downloaded => _downloaded;

  /// Save cache to local storage
  static Future<void> saveToStorage() async {
    if (_cache == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = <String, List<Map<String, dynamic>>>{};
      for (final entry in _cache!.entries) {
        data[entry.key] = entry.value.map((l) => {
          'id': l.id,
          'title': l.title,
          'url': l.docUrl,
        }).toList();
      }
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      print('LawsCache: Failed to save to storage: $e');
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
      print('LawsCache: Failed to load from storage: $e');
    }
    return null;
  }
}

/// Repository for laws data - online first, cached for offline
class LawsRepository {
  final String languageCode;
  
  LawsRepository({required this.languageCode});

  /// Clear cache to force refresh (clears ALL languages)
  void clearCache() {
    LawsCache.clear();
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

  /// Convert remote/stored data to LawDocument list
  List<LawDocument> _convertData(List<Map<String, dynamic>> data, String lang) {
    return data.asMap().entries.map((entry) {
      // Try to parse date from API, fallback to null (will show no date)
      DateTime? docDate;
      if (entry.value['date'] != null) {
        try {
          docDate = DateTime.parse(entry.value['date'].toString());
        } catch (_) {}
      }
      
      return LawDocument(
        id: entry.value['id'] ?? '',
        index: entry.key + 1,
        title: entry.value['title'] ?? '',
        issuer: _getIssuer(lang),
        docNumber: entry.value['id'] ?? '',
        date: docDate,
        content: '',
        pdfUrl: (entry.value['url'] ?? '').replaceAll('/docs/', '/pdfs/'),
        docUrl: entry.value['url'] ?? '',
      );
    }).toList();
  }

  /// Load laws for current language only
  Future<void> _loadData() async {
    // Wait if already loading
    while (LawsCache.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    // If cache has data for current language, check if update needed
    if (LawsCache.cache != null && 
        LawsCache.cache![languageCode] != null &&
        LawsCache.cache![languageCode]!.isNotEmpty) {
      _checkAndUpdateInBackground();
      return;
    }
    
    LawsCache.setLoading(true);

    try {
      // First, load from local storage
      final storedData = await LawsCache.loadFromStorage();
      
      if (storedData != null && storedData[languageCode] != null) {
        final cache = LawsCache.cache ?? <String, List<LawDocument>>{};
        cache[languageCode] = _convertData(storedData[languageCode]!, languageCode);
        LawsCache.setCache(cache);
      }

      // Check if we need to fetch new data
      final hasUpdates = await MetadataService.hasUpdates();
      final cacheEmpty = LawsCache.cache == null || 
                         LawsCache.cache![languageCode] == null || 
                         LawsCache.cache![languageCode]!.isEmpty;
      
      if (hasUpdates || cacheEmpty) {
        final remoteData = await LawsService.fetchLaws(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = LawsCache.cache ?? <String, List<LawDocument>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          LawsCache.setCache(cache);
          await LawsCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('LawsRepository: Failed to load: $e');
    } finally {
      LawsCache.setLoading(false);
    }
  }

  /// Check for updates in background without blocking UI
  Future<void> _checkAndUpdateInBackground() async {
    try {
      final hasUpdates = await MetadataService.hasUpdates();
      if (hasUpdates) {
        final remoteData = await LawsService.fetchLaws(languageCode);
        if (remoteData.isNotEmpty) {
          final cache = LawsCache.cache ?? <String, List<LawDocument>>{};
          cache[languageCode] = _convertData(remoteData, languageCode);
          LawsCache.setCache(cache);
          await LawsCache.saveToStorage();
          await MetadataService.saveTimestamp();
        }
      }
    } catch (e) {
      print('LawsRepository: Background update failed: $e');
    }
  }

  Future<List<LawDocument>> getLaws({
    LawFilter filter = LawFilter.all,
    LawSort sort = LawSort.newest,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    // Load if cache is empty for current language
    if (LawsCache.cache == null || 
        LawsCache.cache?[languageCode] == null ||
        LawsCache.cache![languageCode]!.isEmpty) {
      await _loadData();
    }

    var laws = List<LawDocument>.from(LawsCache.cache?[languageCode] ?? []);

    // Apply favorites/downloaded status
    laws = laws.map((l) => l.copyWith(
      isFavorite: LawsCache.favorites.contains(l.id),
      isDownloaded: LawsCache.downloaded.contains(l.id),
    )).toList();

    // Apply filter
    switch (filter) {
      case LawFilter.favorites:
        laws = laws.where((l) => l.isFavorite).toList();
        break;
      case LawFilter.downloaded:
        laws = laws.where((l) => l.isDownloaded).toList();
        break;
      case LawFilter.all:
        break;
    }

    // Apply search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      laws = laws.where((l) {
        final title = l.title.toLowerCase();
        final docNum = l.docNumber.toLowerCase();
        return title.contains(query) || docNum.contains(query);
      }).toList();
    }

    // Apply sort
    switch (sort) {
      case LawSort.newest:
        laws.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return b.date!.compareTo(a.date!);
        });
        break;
      case LawSort.oldest:
        laws.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return a.date!.compareTo(b.date!);
        });
        break;
      case LawSort.alphabetical:
        laws.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    // Apply pagination
    if (offset != null && limit != null) {
      final end = (offset + limit).clamp(0, laws.length);
      laws = laws.sublist(offset.clamp(0, laws.length), end);
    }

    return laws;
  }

  Future<LawDocument?> getLawById(String id) async {
    if (LawsCache.cache == null || LawsCache.cache?[languageCode]?.isEmpty == true) {
      await _loadData();
    }
    try {
      final law = LawsCache.cache?[languageCode]?.firstWhere((l) => l.id == id);
      if (law != null) {
        return law.copyWith(
          isFavorite: LawsCache.favorites.contains(id),
          isDownloaded: LawsCache.downloaded.contains(id),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleFavorite(String id) async {
    if (LawsCache.favorites.contains(id)) {
      LawsCache.favorites.remove(id);
    } else {
      LawsCache.favorites.add(id);
    }
  }

  Future<void> downloadLaw(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    LawsCache.downloaded.add(id);
  }
}

/// Provider for laws repository - depends on language
final lawsRepositoryProvider = Provider<LawsRepository>((ref) {
  final language = ref.watch(languageProvider);
  return LawsRepository(languageCode: language.code);
});

/// Provider for laws list
final lawsListProvider = FutureProvider.autoDispose.family<List<LawDocument>, ({LawFilter filter, LawSort sort, String? query})>(
  (ref, params) async {
    final repository = ref.watch(lawsRepositoryProvider);
    return repository.getLaws(
      filter: params.filter,
      sort: params.sort,
      searchQuery: params.query,
    );
  },
);

/// Provider for single law
final lawDetailProvider = FutureProvider.family<LawDocument?, String>(
  (ref, id) async {
    final repository = ref.watch(lawsRepositoryProvider);
    return repository.getLawById(id);
  },
);
