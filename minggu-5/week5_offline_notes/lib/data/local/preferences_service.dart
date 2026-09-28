
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyLastOpened = 'last_opened_at';

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> saveLastOpened() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastOpened, DateTime.now().toIso8601String());
  }

  Future<String?> getLastOpened() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastOpened);
  }
}