import 'package:fasttrackgarage_app/utils/Constants.dart';
import 'package:fasttrackgarage_app/utils/SPUtils.dart';

class PrefsManager {
  static Future<void> saveUsernameToPrefs(String username) async {
    await SpUtil.putString(Constants.userName, username);
  }

  static Future<void> saveLoginCredentialsToPrefs(
      String custNumber,
      String username,
      String email,
      String basicToken,
      String mobileNumber) async {
        print("saved login credentials $custNumber $username $email $basicToken $mobileNumber");
  
   SpUtil.putString(Constants.customerNo, custNumber);
   SpUtil.putString(Constants.customerName, username);
   SpUtil.putString(Constants.customerEmail, email);
   SpUtil.putString(Constants.basicToken, basicToken);
   SpUtil.putString(Constants.customerMobileNo, mobileNumber);
  }

  static Future<bool> checkSession() async {
    String customerNumber = SpUtil.getString(Constants.customerNo);
    if (customerNumber != null) {
      if (!customerNumber.isEmpty) {
        return true;
      }
    }

    return false;
  }

  static Future<String> getBasicToken() async {
   
    return SpUtil.getString(Constants.basicToken);
  }

  static Future<void> clearSession() async {
    await SpUtil.putString(Constants.customerNo, "");
    await SpUtil.putString(Constants.customerName, "");
    await SpUtil.putString(Constants.customerEmail, "");
    await SpUtil.putString(Constants.basicToken, "");
  }

  static Future<void> saveAndroidVersion(String value) async {
    await SpUtil.putString(Constants.versionNo, value);
  }
}
