import 'dart:collection';
import '../services/auth/auth_service.dart';
import '../services/auth/auth_user.dart';
import '../storage/cached_object.dart';

class UserCache {

  static final Map<String, CachedObject<AuthUser?>> _cache = HashMap();

  /// Run a garbage disposal task to get
  /// rid of invalidated cache
  static void dispose() {
    _cache.forEach((key, value) {
      if (!value.isValid()) {
        _cache.remove(key);
      }
    });
  }

  static Future<AuthUser?> get(String uuid) {
    // try cache
    if (_cache.containsKey(uuid)) {
      CachedObject<AuthUser?> c = _cache[uuid]!;
      if (c.isValid()) {
        return Future.value(_cache[uuid]!.get());
      }
    }
    // if not cached, fetch from db
    return fetchFromDatabase(uuid);
  }

  /// Fetch data directly from database
  static Future<AuthUser?> fetchFromDatabase(String uuid) async {
    AuthUser? u = await AuthService.firebase().getUser(uuid);
    // cache it before returning
    if (_cache.containsKey(uuid)) {
      _cache[uuid]!.set(u);
    }
    else {
      _cache[uuid] = CachedObject(object: u, validFor: 20000);
    }
    return u;
  }
}
