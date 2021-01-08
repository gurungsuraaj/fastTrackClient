import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static Future<void> saveUsernameToPrefs(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.USERNAME, username);
  }

  static Future<void> saveLoginCredentialsToPrefs(
      String custNumber,
      String username,
      String email,
      String basicToken,
      String mobileNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.CUSTOMER_NUMBER, custNumber);
    await prefs.setString(Constants.CUSTOMER_NAME, username);
    await prefs.setString(Constants.CUSTOMER_EMAIL, email);
    await prefs.setString(Constants.BASIC_TOKEN, basicToken);
    await prefs.setString(Constants.CUSTOMER_MOBILE_NO, mobileNumber);
  }

  static Future<bool> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    String customerNumber = await prefs.getString(Constants.CUSTOMER_NUMBER);
    if (customerNumber != null) {
      if (!customerNumber.isEmpty) {
        return true;
      }
    }

    return false;
  }

  static Future<String> getBasicToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getString(Constants.BASIC_TOKEN);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.CUSTOMER_NUMBER, "");
    await prefs.setString(Constants.CUSTOMER_NAME, "");
    await prefs.setString(Constants.CUSTOMER_EMAIL, "");
    await prefs.setString(Constants.BASIC_TOKEN, "");
  }

  static Future<void> saveAndroidVersion(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.VERSION_NO, value);
  }
}
