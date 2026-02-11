import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'metadata_service.dart';

/// Service that handles automatic data refresh on app launch and periodically
class DataRefreshService {
  static const Duration _refreshInterval = Duration(minutes: 30);
  static Timer? _periodicTimer;
  static bool _isRefreshing = false;
  static DateTime? _lastRefresh;

  /// Initialize and start background refresh
  static Future<void> initialize() async {
    // Check for updates on app launch (non-blocking)
    _checkForUpdates();

    // Start periodic refresh
    _startPeriodicRefresh();
  }

  /// Start periodic background refresh
  static void _startPeriodicRefresh() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_refreshInterval, (_) {
      _checkForUpdates();
    });
  }

  /// Stop periodic refresh (call on app dispose)
  static void dispose() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  /// Check for updates - only downloads metadata (1KB) to see if data changed
  static Future<void> _checkForUpdates() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {
      print('DataRefreshService: Checking for updates...');
      
      final hasUpdates = await MetadataService.hasUpdates();
      
      if (hasUpdates) {
        print('DataRefreshService: Updates available, will refresh on next screen load');
      } else {
        print('DataRefreshService: No updates available');
      }

      _lastRefresh = DateTime.now();
    } catch (e) {
      print('DataRefreshService: Check failed: $e');
    } finally {
      _isRefreshing = false;
    }
  }

  /// Force refresh - invalidates cache and triggers update check
  static Future<void> forceRefresh() async {
    MetadataService.invalidateCache();
    await _checkForUpdates();
  }
}

/// Provider for manual refresh trigger
final dataRefreshProvider = FutureProvider<void>((ref) async {
  await DataRefreshService.forceRefresh();
});
