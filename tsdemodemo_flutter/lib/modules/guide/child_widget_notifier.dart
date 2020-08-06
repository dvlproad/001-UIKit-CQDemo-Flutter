import 'package:flutter/material.dart';

class ChildWidgetChangeNotifier extends ChangeNotifier {
  RenderBox _likeButtonRenderBox;
  RenderBox _photoButtonRenderBox;

  // ChildWidgetChangeNotifier(this._likeButtonRenderBox, this._photoButtonRenderBox);

  void changeRendexBoxs(likeButtonRenderBox, photoButtonRenderBox) {
    print('更新RenderBoxs成功');
    _likeButtonRenderBox = likeButtonRenderBox;
    _photoButtonRenderBox = photoButtonRenderBox;
    notifyListeners();
  }

  RenderBox get likeButtonRenderBox => _likeButtonRenderBox;
  RenderBox get photoButtonRenderBox => _photoButtonRenderBox;
}
