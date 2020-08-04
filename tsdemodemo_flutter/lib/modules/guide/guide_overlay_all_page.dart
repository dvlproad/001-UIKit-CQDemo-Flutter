import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page1.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page2.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page3.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page4.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page5.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_page6.dart';

typedef GetButtonAnchorKeyCallback = GlobalKey Function();
typedef GetRenderBoxCallback = RenderBox Function();

class GuideOverlayEntryFactory2 {
  BuildContext context;

  GetButtonAnchorKeyCallback getButtonAnchorKeyCallback1;
  GetRenderBoxCallback getRenderBoxCallback1;

  GuideOverlayEntryFactory2({
    this.context,
    this.getButtonAnchorKeyCallback1,
    this.getRenderBoxCallback1,
  });

  OverlayEntry overlayEntry1,
      overlayEntry2,
      overlayEntry3,
      overlayEntry4,
      overlayEntry5,
      overlayEntry6;

  var overlayPageIndex = 0;
  void clickOverlayPageIndex() {
    // if (overlayPageIndex == 0) {
    //   overlayEntry1.remove();
    //   overlayEntry2 = getOverlayEntry2();
    //   Overlay.of(context).insert(overlayEntry2);
    // } else if (overlayPageIndex == 1) {
    //   overlayEntry2.remove();
    //   overlayEntry3 = getOverlayEntry3();
    //   Overlay.of(context).insert(overlayEntry3);
    // } else if (overlayPageIndex == 2) {
    //   overlayEntry3.remove();
    //   overlayEntry4 = getOverlayEntry4();
    //   Overlay.of(context).insert(overlayEntry4);
    // } else if (overlayPageIndex == 3) {
    //   overlayEntry4.remove();
    //   overlayEntry5 = getOverlayEntry5();
    //   Overlay.of(context).insert(overlayEntry5);
    // } else if (overlayPageIndex == 4) {
    //   overlayEntry5.remove();
    //   overlayEntry6 = getOverlayEntry6();
    //   Overlay.of(context).insert(overlayEntry6);
    // } else if (overlayPageIndex == 5) {
    //   overlayEntry6.remove();
    // }
    if (overlayPageIndex == 0) {
      overlayEntry1.remove();
      overlayEntry6 = getOverlayEntry6();
      Overlay.of(context).insert(overlayEntry6);
    } else if (overlayPageIndex == 1) {
      overlayEntry6.remove();
    }
    overlayPageIndex++;
  }

  OverlayEntry getOverlayEntry1() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage1(iKnowOnPressed: this.clickOverlayPageIndex);
    });
  }

  OverlayEntry getOverlayEntry2() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage2(iKnowOnPressed: this.clickOverlayPageIndex);
    });
  }

  OverlayEntry getOverlayEntry3() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage3(iKnowOnPressed: this.clickOverlayPageIndex);
    });
  }

  OverlayEntry getOverlayEntry4() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage4(iKnowOnPressed: this.clickOverlayPageIndex);
    });
  }

  OverlayEntry getOverlayEntry5() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage5(iKnowOnPressed: this.clickOverlayPageIndex);
    });
  }

  OverlayEntry getOverlayEntry6() {
    // GlobalKey buttonAnchorKey1 = this.getButtonAnchorKeyCallback1();
    // RenderBox renderBox1 = buttonAnchorKey1.currentContext.findRenderObject();
    RenderBox renderBox1 = this.getRenderBoxCallback1();
    // 获得控件左上角方的坐标
    Offset offset1 = renderBox1.localToGlobal(Offset.zero);
    // // 获得控件右上角的坐标
    // var offset1 = renderBox1.localToGlobal(Offset(0.0, renderBox1.size.width));
    print('当前控件的横坐标2:' + offset1.dx.toString());
    print('当前控件的纵坐标:' + offset1.dy.toString());

    double right1 = offset1.dx;
    double bottom1 = offset1.dy;
    double right2 = 0;
    double bottom2 = 20;

    return OverlayEntry(builder: (context) {
      return GuideOverlayPage6(
        right1: right1,
        bottom1: bottom1,
        right2: right2,
        bottom2: bottom2,
        iKnowOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  void addGuideOverlayEntrys() {
    overlayEntry1 = getOverlayEntry1();
    Overlay.of(context).insert(overlayEntry1);

    // List<OverlayEntry> overlayEntryList = List<OverlayEntry>();
    // overlayEntryList.add(overlayEntry1);
    // overlayEntryList.add(overlayEntry2);
    // overlayEntryList.add(overlayEntry3);
    // Overlay.of(context).insertAll(overlayEntryList);
  }
}
