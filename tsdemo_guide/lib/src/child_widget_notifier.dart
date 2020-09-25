import 'package:flutter/material.dart';

class ChildWidgetChangeNotifier extends ChangeNotifier {
  RenderBox _likeButtonRenderBox;
  RenderBox _photoButtonRenderBox;
  bool _canStartShow = false; // 是否可以开始加载显示引导蒙层
  bool _hasShowOver = false; // 引导蒙层是否显示操作完毕

  // ChildWidgetChangeNotifier(this._likeButtonRenderBox, this._photoButtonRenderBox);

  RenderBox get likeButtonRenderBox => _likeButtonRenderBox;
  RenderBox get photoButtonRenderBox => _photoButtonRenderBox;
  bool get canStartShow => _canStartShow;
  bool get hasShowOver => _hasShowOver;

  void changeRendexBoxs(likeButtonRenderBox, photoButtonRenderBox) {
    print('更新RenderBoxs成功');
    _likeButtonRenderBox = likeButtonRenderBox;
    _photoButtonRenderBox = photoButtonRenderBox;
    notifyListeners();
  }

  void showStart(bool canShow) {
    print('是否可以开始显示引导蒙层');
    _canStartShow = canShow;
    notifyListeners();
  }

  void showOver() {
    print('展示结束');
    _hasShowOver = true;
    notifyListeners();
  }
}
