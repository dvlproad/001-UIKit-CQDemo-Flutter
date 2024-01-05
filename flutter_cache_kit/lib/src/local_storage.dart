// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_null_comparison, dead_code, unnecessary_type_check, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  /*
  // 工厂模式
  factory LocalStorage() => _getInstance();
  static LocalStorage get instance => _getInstance();
  static LocalStorage _instance;
  LocalStorage._internal() {
    // 初始化
    init();
  }

  init() {
    _getCache();
  }

  static SharedPreferences _sharePrefs;
  static SharedPreferences get prefs async {
    if (_sharePrefs == null) {
      _sharePrefs = await SharedPreferences.getInstance();
    }
    return _sharePrefs;
  }

  // static SharedPreferences prefs;
  void _getCache() async {
    // prefs = await SharedPreferences.getInstance();
  }

  static LocalStorage _getInstance() {
    if (_instance == null) {
      _instance = new LocalStorage._internal();
    }
    return _instance;
  }
  */

  // 清空所有 key
  static Future<bool> cleanAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> save(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      return prefs.setString(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is Map) {
      return _saveMapOrMaps(key, value);
    } else if (value is List<String>) {
      if (value.isEmpty) {
        return prefs.setStringList(key, value);
      }
      if (value.first is String) {
        return prefs.setStringList(key, value);
      } else if (value.first is Map) {
        return _saveMapOrMaps(key, value);
      } else {
        Type type = value.first.runtimeType;
        throw Exception(
            'SharedPreferences缓存列表的时候，列表里的数据只能是String。当前类型${type.toString()}无法保存，请尝试使用saveCustomBean');
      }
    } else {
      Type type = value.runtimeType;
      throw Exception('此类型${type.toString()}无法保存错误，请尝试使用saveCustomBean');
    }
  }

  /*
  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double?> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
  */
  static Future<T?> get<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String typeString = T.runtimeType.toString();
    if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T is List<String> || T.toString() == 'List<String>') {
      return prefs.getStringList(key) as T?;
    } else if (T is Map) {
      String? mapString = prefs.getString(key);
      if (mapString == null) {
        return null;
      }
      Map<String, dynamic> map = json.decode(mapString);
      return map as T;
      // } else if (T is List<Map<String, dynamic>>) {
    } else if (T is List<Map> || T is List<List>) {
      return getObjects(key) as T;
    } else {
      return prefs.get(key) as T;
      String typeString = T.runtimeType.toString();
      throw Exception('此类型${typeString}无法保存错误，请尝试使用saveCustomBean');
    }
    // else {
    //   return prefs.get(key);
    // }
  }

  static Future<bool> saveStrings(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStrings(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? strings = prefs.getStringList(key);
    return strings;
  }

  static Future<bool> saveObjects(String key, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String objectString = json.encode(value);
    return prefs.setString(key, objectString);
  }

  static Future<List?> getObjects(String key) async {
    // List<Map<String, dynamic>> maps = [];
    // for (String mapString in mapStrings) {
    //   Map<String, dynamic> map = json.decode(mapString);
    //   maps.add(map);
    // }
    // return maps as T;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listString = prefs.getString(key);
    if (listString == null) {
      return null;
    }
    List list = json.decode(listString);
    return list;
  }

  // 保存自定义类
  static Future<bool> saveCustomBean<T>(
    String key,
    value, {
    required Map<String, dynamic> Function(dynamic bItem) valueToJson,
  }) async {
    return _saveCustom(key, value, itemToJson: valueToJson);
  }

  static Future<bool> saveCustomBeans(
    String key,
    value, {
    required Map<String, dynamic> Function(dynamic bItem) itemToJson,
  }) async {
    return _saveCustom(key, value, itemToJson: itemToJson);
  }

  static Future<bool> _saveCustom(
    String key,
    value, {
    required Map<String, dynamic> Function(dynamic bItem) itemToJson,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is List) {
      List<String> strings = [];
      for (var item in value) {
        Map map = itemToJson(item);
        try {
          String mapString = json.encode(map);
          strings.add(mapString);
        } catch (err) {
          return false; // save failure
        }
      }
      return prefs.setStringList(key, strings);
    } else {
      Map<String, dynamic> map = itemToJson(value);
      String mapString = json.encode(map);

      return prefs.setString(key, mapString);
    }
  }

  static Future<bool> _saveMapOrMaps(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is List<Map>) {
      List<String> strings = [];
      for (Map item in value) {
        Map map = item;
        try {
          String mapString = json.encode(map);
          strings.add(mapString);
        } catch (err) {
          return false; // save failure
        }
      }
      return prefs.setStringList(key, strings);
    } else if (value is Map<String, dynamic>) {
      Map<String, dynamic> map = value;
      String mapString = json.encode(map);

      return prefs.setString(key, mapString);
    } else {
      Type type = value.runtimeType;
      throw Exception('此类型${type.toString()}无法保存错误，请尝试使用saveCustomBean');
    }
  }

  // 获取自定义类
  static Future<T?> getCustomBean<T>(
    String key, {
    required T Function(Map<String, dynamic> bMap) fromJson,
  }) async {
    if (fromJson == null) {
      throw Exception("请设置fromJson");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? mapString = prefs.getString(key);
    if (mapString == null) {
      return null;
    }

    Map<String, dynamic> map = json.decode(mapString);
    T customBean = fromJson(map);

    return customBean;
  }

  static Future<List<T>?> getCustomBeans<T>(
    String key, {
    required T Function(Map<String, dynamic> bMap) fromJson,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? mapStrings = prefs.getStringList(key);
    if (mapStrings == null) {
      return null;
    }

    List<T> customBeans = [];
    for (String mapString in mapStrings) {
      Map<String, dynamic> map = json.decode(mapString);
      T customBean = fromJson(map);
      customBeans.add(customBean);
    }
    return customBeans;
  }
}
