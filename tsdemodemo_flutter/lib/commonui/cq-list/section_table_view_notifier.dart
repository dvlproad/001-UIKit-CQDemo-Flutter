import 'package:flutter/cupertino.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/index_path.dart';

typedef void SectionTableViewScrollToCallBack(int section, int row, bool isScrollDown);

class SectionTableController extends ChangeNotifier {
  IndexPath topIndex = IndexPath(section: 0, row: -1);
  bool dirty = false;
  bool animate = false;
  SectionTableViewScrollToCallBack sectionTableViewScrollTo;

  SectionTableController({this.sectionTableViewScrollTo});

  void jumpTo(int section, int row) {
    topIndex = IndexPath(section: section, row: row);
    animate = false;
    dirty = true;
    notifyListeners();
  }

  Future<bool> animateTo(int section, int row) {
    topIndex = IndexPath(section: section, row: row);
    animate = true;
    dirty = true;
    notifyListeners();
    return Future.delayed(Duration(milliseconds: 251), () => true);
  }
}