import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {

  static Future<void> saveUsernameToPrefs(String username) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.USERNAME, username);
  }

  static Future<void> saveLoginCredentialsToPrefs(String custNumber, String username, String email) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.CUSTOMER_NUMBER, custNumber);
    await prefs.setString(Constants.CUSTOMER_NAME, username);
    await prefs.setString(Constants.CUSTOMER_EMAIL, email);
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


}
