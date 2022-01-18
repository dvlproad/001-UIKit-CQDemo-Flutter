import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> save(String key, value) async {
    if (value is Object == false) {}
    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    }
    return prefs.setStringList(key, value);
  }

  static Future<bool> cleanAll() async {
    return prefs.clear();
  }

  static Future<bool> signOut() async {
    return await prefs.remove("tokenkey");
  }

  static Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  static get<T>(String key) {
    if (T is String) {
      return prefs.getString(key) as T;
    } else if (T is int) {
      return prefs.getInt(key) as T;
    } else if (T is double) {
      return prefs.getDouble(key) as T;
    } else if (T is bool) {
      return prefs.getBool(key) as T;
    } else if (T is List<String>) {
      return prefs.getStringList(key) as T;
    }
    return prefs.get(key);
  }
}
