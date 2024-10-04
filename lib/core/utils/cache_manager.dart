import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Manages caching operations for the application.
///
/// This utility class provides methods to interact with the app's cache,
/// allowing for operations such as clearing the cache.
class CacheManager {
  /// Clears all cached data in the application.
  ///
  /// This method empties the entire cache managed by [DefaultCacheManager].
  /// It's useful for freeing up storage space or resetting the app's cached state.
  ///
  /// Returns a [Future] that completes when the cache has been cleared.
  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }
}
