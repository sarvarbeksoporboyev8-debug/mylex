import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service to check if remote data has been updated
class MetadataService {
  static const String _baseUrl = 'https://raw.githubusercontent.com/sarvarbeksoporboyev8-debug/mylex-news-data/main';
  static const String _metadataUrl = '$_baseUrl/metadata.json';
  static const String _localTimestampKey = 'data_last_updated';
  static const Duration _timeout = Duration(seconds: 10);

  static String? _cachedRemoteTimestamp;
  static DateTime? _lastCheck;

  /// Check if remote data has been updated since last fetch
  /// Returns true if we need to download new data
  static Future<bool> hasUpdates() async {
    try {
      // Don't check more than once per minute
      if (_lastCheck != null && 
          DateTime.now().difference(_lastCheck!) < const Duration(minutes: 1) &&
          _cachedRemoteTimestamp != null) {
        final localTimestamp = await _getLocalTimestamp();
        return localTimestamp != _cachedRemoteTimestamp;
      }

      // Fetch remote metadata
      final response = await http.get(Uri.parse(_metadataUrl)).timeout(_timeout);
      if (response.statusCode != 200) {
        print('MetadataService: Failed to fetch metadata: ${response.statusCode}');
        return false; // Assume no updates if can't check
      }

      final metadata = jsonDecode(response.body);
      final remoteTimestamp = metadata['last_updated'] as String?;
      
      if (remoteTimestamp == null) {
        return false;
      }

      _cachedRemoteTimestamp = remoteTimestamp;
      _lastCheck = DateTime.now();

      // Compare with local
      final localTimestamp = await _getLocalTimestamp();
      
      if (localTimestamp == null) {
        print('MetadataService: No local data, need to download');
        return true;
      }

      final hasUpdates = localTimestamp != remoteTimestamp;
      print('MetadataService: Local=$localTimestamp, Remote=$remoteTimestamp, HasUpdates=$hasUpdates');
      
      return hasUpdates;
    } catch (e) {
      print('MetadataService: Error checking updates: $e');
      return false; // Assume no updates on error
    }
  }

  /// Get locally stored timestamp
  static Future<String?> _getLocalTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localTimestampKey);
  }

  /// Save timestamp after successful download
  static Future<void> saveTimestamp() async {
    if (_cachedRemoteTimestamp != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localTimestampKey, _cachedRemoteTimestamp!);
      print('MetadataService: Saved timestamp $_cachedRemoteTimestamp');
    }
  }

  /// Force refresh on next check
  static void invalidateCache() {
    _cachedRemoteTimestamp = null;
    _lastCheck = null;
  }
}
