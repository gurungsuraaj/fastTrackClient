import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';

class PrefsManager {
  static Future<void> saveUsernameToPrefs(String username) async {
    await SpUtil.putString(Constants.USERNAME, username);
  }

  static Future<void> saveLoginCredentialsToPrefs(
      String custNumber,
      String username,
      String email,
      String basicToken,
      String mobileNumber) async {
        print("saved login credentials $custNumber $username $email $basicToken $mobileNumber");
  
   SpUtil.putString(Constants.CUSTOMER_NUMBER, custNumber);
   SpUtil.putString(Constants.CUSTOMER_NAME, username);
   SpUtil.putString(Constants.CUSTOMER_EMAIL, email);
   SpUtil.putString(Constants.BASIC_TOKEN, basicToken);
   SpUtil.putString(Constants.CUSTOMER_MOBILE_NO, mobileNumber);
  }

  static Future<bool> checkSession() async {
    String customerNumber = SpUtil.getString(Constants.CUSTOMER_NUMBER);
    if (customerNumber != null) {
      if (!customerNumber.isEmpty) {
        return true;
      }
    }

    return false;
  }

  static Future<String> getBasicToken() async {
   
    return SpUtil.getString(Constants.BASIC_TOKEN);
  }

  static Future<void> clearSession() async {
    await SpUtil.putString(Constants.CUSTOMER_NUMBER, "");
    await SpUtil.putString(Constants.CUSTOMER_NAME, "");
    await SpUtil.putString(Constants.CUSTOMER_EMAIL, "");
    await SpUtil.putString(Constants.BASIC_TOKEN, "");
  }

  static Future<void> saveAndroidVersion(String value) async {
    await SpUtil.putString(Constants.VERSION_NO, value);
  }
}
