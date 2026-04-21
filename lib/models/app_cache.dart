import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const klogin = 'echelon_login';
  static const kThemeMode = 'echelon_theme_mode';
  static const kColorSelection = 'echelon_color_selection';
  static const kLastTab = 'echelon_last_tab';

  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(klogin, false);
  }

  Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(klogin, true);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(klogin) ?? false;
  }

  Future<void> cacheThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kThemeMode, value);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kThemeMode) ?? 'light';
  }

  Future<void> cacheColorSelection(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kColorSelection, value);
  }

  Future<int> getColorSelection() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kColorSelection) ?? 0;
  }

  Future<void> cacheLastTab(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kLastTab, value);
  }

  Future<int> getLastTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kLastTab) ?? 0;
  }
}
