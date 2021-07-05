import 'package:shared_preferences/shared_preferences.dart';

import '../setting_page.dart';

class PreferenceHelper {
  static const String KEY_NUMBER_OF_PAST_DAYS = 'number_of_past_days';
  static const String KEY_NUMBER_OF_COMING_DAYS = 'number_of_coming_days';

  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<int> getNumberOfPastDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY_NUMBER_OF_PAST_DAYS) ??
        SettingPage.NUMBER_OF_PAST_DAYS_INIT;
  }

  static Future<void> setNumberOfPastDays(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(KEY_NUMBER_OF_PAST_DAYS, value);
  }

  static Future<int> getNumberOfComingDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KEY_NUMBER_OF_COMING_DAYS) ??
        SettingPage.NUMBER_OF_COMING_DAYS_INIT;
  }

  static Future<void> setNumberOfComingDays(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(KEY_NUMBER_OF_COMING_DAYS, value);
  }
}
