import 'package:flutter/material.dart';

/// 相册选择的错误码
enum PhotoAlbumSelectErrorCode {
  none, // 没有错误
  exceedLimit, // 超过限制
}

class PhotoAlbumSelectNotifier with ChangeNotifier {
  final int maxSelectedCount;

  PhotoAlbumSelectNotifier({
    this.maxSelectedCount = 9,
  });

  List<int> _selectIndexs = []; // 当前选中的 indexs

  /// 点击了 index
  PhotoAlbumSelectErrorCode addSelectIndex(index) {
    List<int> oldSelectIndexs = this._selectIndexs;
    int oldSelectedCount;
    if (oldSelectIndexs != null) {
      oldSelectedCount = oldSelectIndexs.length;
    } else {
      oldSelectedCount = 0;
    }

    if (this.isContain(index) == false) {
      // 1.点击未选中的
      if (this.maxSelectedCount == 1) {
        // 1.1 如果是单选，变为直选中当前选择的 index
        this._selectIndexs = [index];
        notifyListeners();
        return PhotoAlbumSelectErrorCode.none;
      } else {
        // 1.2 如果是多选，根据是否超过最大数，进行增加选中 或 提示超过数量
        if (oldSelectedCount < this.maxSelectedCount) {
          oldSelectIndexs.add(index);
          notifyListeners();
          return PhotoAlbumSelectErrorCode.none;
        } else {
          return PhotoAlbumSelectErrorCode.exceedLimit;
        }
      }
    } else {
      // 2.点击已选中的
      if (this.maxSelectedCount == 1) {
        // 2.1 如果是单选，则不做处理
        return PhotoAlbumSelectErrorCode.none;
      } else {
        // 2.2 如果是多选，则取消选中
        oldSelectIndexs.remove(index);
        notifyListeners();
        return PhotoAlbumSelectErrorCode.none;
      }
    }
  }

  // 当前 index 是否已经选中了
  bool isContain(index) {
    if (this._selectIndexs == null) {
      return false;
    }

    bool contain = this._selectIndexs.contains(index);
    return contain;
  }
}
