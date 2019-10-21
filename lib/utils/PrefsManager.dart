import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {

  static Future<void> saveUsernameToPrefs(String username) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.USERNAME, username);
  }

  static Future<bool> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString(Constants.USERNAME);
    if (username != null) {
      if (!username.isEmpty) {
        return true;
      }
    }

    return false;
  }


}
