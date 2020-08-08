import 'package:shared_preferences/shared_preferences.dart';

class GuideOverlayUtil {
  /*
   * 利用SharedPreferences存储数据
   */
  Future finishGuideOverlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('ShouldShowGuideOverlayKey', false);
  }

  /*
   * 获取存在SharedPreferences中的数据
   */
  Future shouldShowGuideOverlay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool shouldShowGuide = sharedPreferences.get('ShouldShowGuideOverlayKey');
    if (shouldShowGuide == null) {
      shouldShowGuide = false;
    }

    return shouldShowGuide;
  }
}
