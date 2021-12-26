import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static const ACCOUNT_SESSIONID = 'account_sessionID';

  Future<void> setAccountSessionID(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(ACCOUNT_SESSIONID, value);
  }

  Future<String> getAccountSessionID() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(ACCOUNT_SESSIONID);
  }
}
