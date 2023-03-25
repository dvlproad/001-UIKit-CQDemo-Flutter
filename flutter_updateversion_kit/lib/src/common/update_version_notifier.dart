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
    _isClickAble = b;
    notifyListeners();
  }

  void setProgress(int p) {
    _progress = p;
    if (_progress > 0 && _progress < 100) {
      _updateBtn = "下载中";
    } else if (_progress == 100) {
      _updateBtn = "下载完成";
    }
    notifyListeners();
  }

  void setUpdateBtn(String txt) {
    _updateBtn = txt;
    notifyListeners();
  }

  void setIsHideProgress(bool b) {
    _isHideProgress = b;
    notifyListeners();
  }
}
