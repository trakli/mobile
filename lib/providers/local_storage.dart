import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<SharedPreferences> _sharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  updateTransactionFormDisplay(String formDisplay) async {
    final prefs = await _sharedPreferences();
    await prefs.setString('formDisplay', formDisplay);
  }

  Future<String?> getTransactionFormDisplay() async {
    final prefs = await _sharedPreferences();
    final formDisplay = prefs.getString("formDisplay");
    return formDisplay;
  }

  Future<void> updateGroupSetting(String key, String value) async {
    final prefs = await _sharedPreferences();
    await prefs.setString('group_setting_$key', value);
  }

  Future<String?> getGroupSetting(String key) async {
    final prefs = await _sharedPreferences();
    return prefs.getString('group_setting_$key');
  }
}
