import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManager {
  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }
}
