import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _key = 'userId';

  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, userId);
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_key);
    return userId ?? 0;
  }
}
