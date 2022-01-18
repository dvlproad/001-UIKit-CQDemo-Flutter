import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveCustom(String key, value) async {
    if (prefs == null) {
      await LocalStorage.init(); // await 同步
    }

    if (value is List) {
      List<String> strings = [];
      for (var item in value) {
        Map map = item.toJson();
        String mapString = json.encode(map);
        strings.add(mapString);
      }
      prefs.setStringList(key, strings);
    } else {
      Map map = value.toJson();
      String mapString = json.encode(map);

      return prefs.setString(key, mapString);
    }
  }

  static getCustomBean<T>(String key, {T Function(Map bMap) fromJson}) {
    String mapString = prefs.getString(key);
    if (mapString == null) {
      return null;
    }

    Map map = json.decode(mapString);
    T customBean = fromJson(map);

    return customBean;
  }

  static getCustomBeans<T>(String key, {T Function(Map bMap) fromJson}) {
    List mapStrings = prefs.getStringList(key);
    if (mapStrings == null) {
      return null;
    }

    List<T> customBeans = [];
    for (String mapString in mapStrings) {
      Map map = json.decode(mapString);
      T customBean = fromJson(map);
      customBeans.add(customBean);
    }
    return customBeans;
  }

  static Future<bool> save(String key, value) async {
    if (prefs == null) {
      await LocalStorage.init(); // await 同步
    }

    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is List) {
      return prefs.setStringList(key, value);
    } else {
      Type type = value.runtimeType;
      print('此类型${type.toString()}无法保存错误，请尝试使用saveCustomBean');
    }
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
