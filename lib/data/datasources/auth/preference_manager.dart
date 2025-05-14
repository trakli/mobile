import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceManager {
  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> clearUserId();
  Future<void> clearAll();
  Future<void> onboardingCompleted();
  Future<bool> isOnboardingCompleted();
  SharedPreferences get prefs;
}

@Singleton(as: PreferenceManager)
class PreferenceManagerImpl implements PreferenceManager {
  static const _userIdKey = 'user_id';
  static const _onboardingCompletedKey = 'onboarding_completed';

  late final SharedPreferences _prefs;

  @override
  SharedPreferences get prefs => _prefs;

  @override
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  @override
  Future<void> onboardingCompleted() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
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
  void init() {
    initStart();
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
