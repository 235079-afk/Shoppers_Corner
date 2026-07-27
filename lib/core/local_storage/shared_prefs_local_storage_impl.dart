import 'package:shared_preferences/shared_preferences.dart';

import 'base_local_storage.dart';

class SharedPrefsLocalStorageImpl implements BaseLocalStorage {
  final SharedPreferences preferences;

  const SharedPrefsLocalStorageImpl({required this.preferences});

  @override
  Future<String?> getString(String key) async {
    return preferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return preferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) {
    return preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await preferences.clear();
  }
}
