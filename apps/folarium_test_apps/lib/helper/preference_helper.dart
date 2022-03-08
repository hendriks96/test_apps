import 'package:folarium_test_apps/global/string_global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static Future<bool> getFirstOpen() async {
    bool isFirstOpen = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstOpen = prefs.getBool(StringGlobal.IS_FIRST_OPEN_KEY) ?? true;
    return isFirstOpen;
  }

  static setFirstOpen(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StringGlobal.IS_FIRST_OPEN_KEY, status);
  }

  static Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(StringGlobal.USER_ID_KEY) ?? 0;
  }

  static setUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StringGlobal.USER_ID_KEY, userId);
  }

  static Future<String> getTokenId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StringGlobal.TOKEN_ID_KEY) ?? '';
  }

  static setTokenId(String tokenId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StringGlobal.TOKEN_ID_KEY, tokenId);
  }
}
