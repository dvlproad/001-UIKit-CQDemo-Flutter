import 'package:shared_preferences/shared_preferences.dart';

class GuideOverlayUtil {
  /*
   * 利用SharedPreferences存储数据
   */
  Future finishGuideOverlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('GuideOverlayFinishKey', true);
  }

  /*
   * 获取存在SharedPreferences中的数据
   */
  Future shouldShowGuideOverlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get('GuideOverlayFinishKey');
  }
}
