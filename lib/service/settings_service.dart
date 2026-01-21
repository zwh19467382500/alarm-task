import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late final SharedPreferences _prefs;
  static const _skippedLoginKey = 'has_skipped_login';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setSkippedLogin(bool value) async {
    await _prefs.setBool(_skippedLoginKey, value);
  }

  bool hasSkippedLogin() {
    return _prefs.getBool(_skippedLoginKey) ?? false;
  }
}
