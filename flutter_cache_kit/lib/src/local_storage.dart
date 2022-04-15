import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  LocalStorage._();

  static SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

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
    return prefs.clear();
  }

  static Future<bool> remove(String key) async {
    return prefs.remove(key);
  }

  static Future<bool> save(String key, value) async {
    if (prefs == null) {
      showShouldInit();
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
      throw Exception('此类型${type.toString()}无法保存错误，请尝试使用saveCustomBean');
    }
  }

  static get<T>(String key) {
    if (prefs == null) {
      showShouldInit();
    }

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

  // 保存自定义类
  static Future<bool> saveCustomBean<T>(
    String key,
    value, {
    Map Function(dynamic bItem) valueToJson,
  }) async {
    return _saveCustom(key, value, itemToJson: valueToJson);
  }

  static Future<bool> saveCustomBeans(
    String key,
    value, {
    Map Function(dynamic bItem) itemToJson,
  }) async {
    return _saveCustom(key, value, itemToJson: itemToJson);
  }

  static Future<bool> _saveCustom(
    String key,
    value, {
    Map Function(dynamic bItem) itemToJson,
  }) async {
    if (prefs == null) {
      showShouldInit();
    }

    if (value is List) {
      List<String> strings = [];
      for (var item in value) {
        Map map = itemToJson(item);
        String mapString = json.encode(map);
        strings.add(mapString);
      }
      return prefs.setStringList(key, strings);
    } else {
      Map map = itemToJson(value);
      String mapString = json.encode(map);

      return prefs.setString(key, mapString);
    }
  }

  // 获取自定义类
  static getCustomBean<T>(
    String key, {
    T Function(Map bMap) fromJson,
  }) {
    if (fromJson == null) {
      throw Exception("请设置fromJson");
    }
    if (prefs == null) {
      showShouldInit();
    }

    String mapString = prefs.getString(key);
    if (mapString == null) {
      return null;
    }

    Map map = json.decode(mapString);
    T customBean = fromJson(map);

    return customBean;
  }

  static getCustomBeans<T>(String key, {T Function(Map bMap) fromJson}) {
    if (prefs == null) {
      showShouldInit();
    }

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

  static void showShouldInit() {
    throw Exception('Error:请先执行await LocalStorage.init();');
  }
}
