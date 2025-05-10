import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceManager {
  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> clearUserId();
}

@Injectable(as: PreferenceManager)
class PreferenceManagerImpl implements PreferenceManager {
  static const _userIdKey = 'user_id';
  late final SharedPreferences _prefs;

  @override
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  @override
  Future<int?> getUserId() async {
    return _prefs.getInt(_userIdKey);
  }

  @override
  Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }

  Future<void> initStart() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @postConstruct
  voidinit() {
    initStart();
  }
}
