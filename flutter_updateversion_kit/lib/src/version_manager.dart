/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-08 14:10:40
 * @Description: 
 */
class VersionManager {
  bool _firstShow = false;

  static final VersionManager _instance = VersionManager._internal();
  factory VersionManager() => _instance;
  static VersionManager get instance => _instance;
  VersionManager._internal() {
    _firstShow = true;
  }

  bool get firstSHow => _firstShow;
  void setFirstShow(bool b) {
    this._firstShow = b;
  }
}
