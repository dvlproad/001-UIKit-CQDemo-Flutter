import 'package:flutter/cupertino.dart';

class UpdateNotifier with ChangeNotifier {
  bool _isClickAble = true;
  int _progress = 0;
  String _updateBtn = "立即升级";
  bool _isHideProgress = true;

  get isHideProgress => _isHideProgress;
  get updateBtn => _updateBtn;
  get progress => _progress;
  get isClickAble => _isClickAble;

  void setIsClickAble(bool b) {
    this._isClickAble = b;
    notifyListeners();
  }

  void setProgress(int p) {
    this._progress = p;
    if (this._progress > 0 && this._progress < 100) {
      this._updateBtn = "下载中";
    } else if (this._progress == 100) {
      this._updateBtn = "下载完成";
    }
    notifyListeners();
  }

  void setUpdateBtn(String txt) {
    this._updateBtn = txt;
    notifyListeners();
  }

  void setIsHideProgress(bool b) {
    this._isHideProgress = b;
    notifyListeners();
  }
}
