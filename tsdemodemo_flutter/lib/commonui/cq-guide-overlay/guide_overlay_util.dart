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
      shouldShowGuide = true;
    }

    shouldShowGuide = true; // 测试专用，正式时候应该去掉
    return shouldShowGuide;
  }
}
