import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Util.
class SpUtil {
  static SpUtil? _singleton;
  static SharedPreferences? _prefs;

  static Future<SpUtil?> getInstance() async {
    if (_singleton == null) {
      // keep local instance till it is fully initialized.
      // Keep the local instance until it is fully initialized.
      var singleton =  SpUtil ._ ();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  SpUtil ._ ();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  static Future<bool>? putObject(String key, Object? value) {
    if (_prefs == null) return null;
    return _prefs!.setString(key, value == null ? "" : json.encode(value));
  }

  /// get obj.
  static T? getObj<T>(String key, T f(Map v), {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map? getObject(String key) {
    if (_prefs == null) return null;
    String? _data = _prefs!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool>? putObjectList(String key, List<Object> list) {
    if (_prefs == null) return null;
    List<String>? _dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs!.setStringList(key, _dataList);
  }

  /// get obj list.
  static List<T> getObjList<T>(String key, T f(Map? v),
      {List<T> defValue = const []}) {
    List<Map?>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map?>? getObjectList(String key) {
    if (_prefs == null) return null;
    List<String>? dataLis = _prefs!.getStringList(key);
    return dataLis?.map((value) {
      Map? _dataMap = json.decode(value);
      return _dataMap;
    }).toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs!.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool>? putString(String key, String? value) {
    if (_prefs == null) return null;
    return _prefs!.setString(key, value!);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs!.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool>? putBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs!.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool>? putInt(String key, int value) {
    if (_prefs == null) return null;
    return _prefs!.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool>? putDouble(String key, double value) {
    if (_prefs == null) return null;
    return _prefs!.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs!.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool>? putStringList(String key, List<String> value) {
    if (_prefs == null) return null;
    return _prefs!.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object? defValue}) {
    if (_prefs == null) return defValue;
    return _prefs!.get(key) ?? defValue;
  }

  /// have key.
  static bool? haveKey(String key) {
    if (_prefs == null) return null;
    return _prefs!.getKeys().contains(key);
  }

  /// get keys.
  static Set<String>? getKeys() {
    if (_prefs == null) return null;
    return _prefs!.getKeys();
  }

  /// remove.
  static Future<bool>? remove(String key) {
    if (_prefs == null) return null;
    return _prefs!.remove(key);
  }

  /// clear.
  static Future<bool>? clear() {
    if (_prefs == null) return null;
    return _prefs!.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }

  static const _theme_key = 'theme_mode';

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_theme_key, _modeToString(mode));
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_theme_key) ?? 'light';
    return _stringToMode(themeStr);
  }

  static String _modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      default:
        return 'light';
    }
  }

  static ThemeMode _stringToMode(String str) {
    switch (str) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
