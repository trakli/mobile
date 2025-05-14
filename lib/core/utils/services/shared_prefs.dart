import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefs {
  Future<bool> putBool(String key, bool value);
  bool? getBool(String key);

  Future<bool> putDouble(String key, double value);
  double? getDouble(String key);

  Future<bool> putInt(String key, int value);
  int? getInt(String key);

  Future<bool> putString(String key, String value);
  String? getString(String key);

  Future<bool> putStringList(String key, List<String> value);
  List<String>? getStringList(String key);

  bool isKeyExists(String key);
  Future<bool> clearKey(String key);
  Future<bool> clearAll();
}

@Singleton(as: SharedPrefs)
class SharedPrefsImpl implements SharedPrefs {
  late final SharedPreferences _prefs;

  @override
  Future<bool> putBool(String key, bool value) => _prefs.setBool(key, value);
  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> putDouble(String key, double value) =>
      _prefs.setDouble(key, value);
  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  Future<bool> putInt(String key, int value) => _prefs.setInt(key, value);
  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> putString(String key, String value) =>
      _prefs.setString(key, value);
  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> putStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  bool isKeyExists(String key) => _prefs.containsKey(key);

  @override
  Future<bool> clearKey(String key) => _prefs.remove(key);

  @override
  Future<bool> clearAll() => _prefs.clear();

  // @postConstruct
  // Future<void> init() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }
}
