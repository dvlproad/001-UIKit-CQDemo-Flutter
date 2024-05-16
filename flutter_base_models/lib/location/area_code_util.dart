/*
 * @Author: dvlproad
 * @Date: 2024-05-16 10:46:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 10:51:54
 * @Description: 
 */
class AreaCodeUtil {
  // 根据区号获取6位的城市代码(高德地图返回的cityCode可能是该城市的电话区号4位)
  static String getCityCodeFromAreaCode(String areaCode) {
    return areaCode.replaceRange(4, 6, '00');
  }

  // 根据区号获取6位的省代码
  static String getProvinceCodeFromAreaCode(String areaCode) {
    return areaCode.replaceRange(2, 6, '00');
  }
}
