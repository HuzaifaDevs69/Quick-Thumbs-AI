import 'package:shared_preferences/shared_preferences.dart';

import 'package:yt_thumb_extract/core/utils/prefs/prefs_constants.dart';

/// A configuration class for managing shared preferences in the application.
class PrefsConfig {
  static late SharedPreferences _prefsInstance;

  /// Initializes the SharedPreferences instance.
  /// Must be called before accessing any preferences.
  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static String getUserId() {
    return _prefsInstance.getString(Constants.userId) ?? '';
  }

  /// Saves the user ID to shared preferences.
  static Future<bool> setUserId(String userId) {
    ArgumentError.checkNotNull(userId, Constants.userId);
    return _prefsInstance.setString(Constants.userId, userId);
  }

  static bool getIsLoggedIn() {
    return _prefsInstance.getBool(Constants.isLoggedIn) ?? false;
  }

  static Future<bool> setIsLoggedIn(bool isLoggedIn) {
    return _prefsInstance.setBool(Constants.isLoggedIn, isLoggedIn);
  }
}
