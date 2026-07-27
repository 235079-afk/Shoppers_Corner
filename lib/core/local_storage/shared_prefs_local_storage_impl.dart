import 'package:shared_preferences/shared_preferences.dart';

import 'base_local_storage.dart';

  
class SharedPrefsLocalStorageImpl implements BaseLocalStorage {
  final SharedPreferences preferences;

  const SharedPrefsLocalStorageImpl({required this.preferences});

  @override
  Future<void> clear({Set<String>? allowList}) async {
    await preferences.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return preferences.containsKey(key);
  }

  @override
  Future<Map<String, Object?>> getAll({Set<String>? allowList}) async {
    // return preferences.getAll();
    final keys = await getKeys(allowList: allowList);
    return Map.fromEntries(
      keys.map((key) => MapEntry(key, preferences.get(key))),
    );
  }

  @override
  Future<bool?> getBool(String key) async {
    return preferences.getBool(key);
  }

  @override
  Future<double?> getDouble(String key) async {
    return preferences.getDouble(key);
  }

  @override
  Future<int?> getInt(String key) async {
    return preferences.getInt(key);
  }

  @override
  Future<Set<String>> getKeys({Set<String>? allowList}) async {
    return preferences.getKeys();
  }

  @override
  Future<String?> getString(String key) async {
    return preferences.getString(key);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return preferences.getStringList(key);
  }

  @override
  Future<void> remove(String key) {
    return preferences.remove(key);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return preferences.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return preferences.setDouble(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return preferences.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return preferences.setString(key, value);
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    return preferences.setStringList(key, value);
  }
}