import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page1.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page2.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page3.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page4.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page5.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_page6.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_util.dart';

typedef GetRenderBoxCallback = RenderBox Function();
typedef FinishGuideOverlayCallback = void Function();

class GuideOverlayAllPage {
  BuildContext context;

  GetRenderBoxCallback
      getOverlayPage6RenderBoxCallback1; // 第6张引导页的第一个视图的 RenderBox
  GetRenderBoxCallback
      getOverlayPage6RenderBoxCallback2; // 第6张引导页的第二个视图的 RenderBox

  FinishGuideOverlayCallback finishGuideOverlayCallback; // 结束引导的回调

  GuideOverlayAllPage({
    this.context,
    this.getOverlayPage6RenderBoxCallback1,
    this.getOverlayPage6RenderBoxCallback2,
    @required this.finishGuideOverlayCallback,
  });

  OverlayEntry overlayEntry1,
      overlayEntry2,
      overlayEntry3,
      overlayEntry4,
      overlayEntry5,
      overlayEntry6;

  var overlayPageIndex = 0;
  void clickOverlayPageIndex() {
    if (overlayPageIndex == 0) {
      overlayEntry1.remove();
      overlayEntry2 = getOverlayEntry2();
      Overlay.of(context).insert(overlayEntry2);
    } else if (overlayPageIndex == 1) {
      overlayEntry2.remove();
      overlayEntry3 = getOverlayEntry3();
      Overlay.of(context).insert(overlayEntry3);
    } else if (overlayPageIndex == 2) {
      overlayEntry3.remove();
      overlayEntry4 = getOverlayEntry4();
      Overlay.of(context).insert(overlayEntry4);
    } else if (overlayPageIndex == 3) {
      overlayEntry4.remove();
      overlayEntry5 = getOverlayEntry5();
      Overlay.of(context).insert(overlayEntry5);
    } else if (overlayPageIndex == 4) {
      overlayEntry5.remove();
      overlayEntry6 = getOverlayEntry6();
      Overlay.of(context).insert(overlayEntry6);
    } else if (overlayPageIndex == 5) {
      overlayEntry6.remove();

      GuideOverlayUtil().finishGuideOverlay();
      this.finishGuideOverlayCallback();
    }
    overlayPageIndex++;
  }

  OverlayEntry getOverlayEntry1() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage1(
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  OverlayEntry getOverlayEntry2() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage2(
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  OverlayEntry getOverlayEntry3() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage3(
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  OverlayEntry getOverlayEntry4() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage4(
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  OverlayEntry getOverlayEntry5() {
    return OverlayEntry(builder: (context) {
      return GuideOverlayPage5(
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
      );
    });
  }

  OverlayEntry getOverlayEntry6() {
    double width = MediaQuery.of(context).size.width;

    bool shouldShow1 = false;
    double right1 = 0;
    double top1 = 0;
    double height1 = 56;
    if (this.getOverlayPage6RenderBoxCallback1 != null) {
      RenderBox renderBox1 = this.getOverlayPage6RenderBoxCallback1();
      if (renderBox1 != null) {
        shouldShow1 = true;
        // 获得控件左上角方的坐标
        Offset offset1 = renderBox1.localToGlobal(Offset.zero);
        // // 获得控件右上角的坐标
        // var offset1 = renderBox1.localToGlobal(Offset(0.0, renderBox1.size.width));
        print('当前控件1的横坐标:' + offset1.dx.toString());
        print('当前控件1的纵坐标:' + offset1.dy.toString());
        right1 = width - offset1.dx - renderBox1.size.width;
        top1 = offset1.dy;

        height1 = renderBox1.size.height;
      }
    }

    bool shouldShow2 = false;
    double right2 = 0;
    double top2 = 0;
    double height2 = 56;
    if (this.getOverlayPage6RenderBoxCallback2 != null) {
      RenderBox renderBox2 = this.getOverlayPage6RenderBoxCallback2();
      if (renderBox2 != null) {
        shouldShow2 = true;
        Offset offset2 = renderBox2.localToGlobal(Offset.zero);
        right2 = width - offset2.dx - renderBox2.size.width;
        top2 = offset2.dy;

        height2 = renderBox2.size.height;
      }
    }

    return OverlayEntry(builder: (context) {
      return GuideOverlayPage6(
        show1: shouldShow1,
        right1: right1,
        top1: top1,
        height1: height1,
        show2: shouldShow2,
        right2: right2,
        top2: top2,
        height2: height2,
        iKnowOnPressed: this.clickOverlayPageIndex,
        backgroundOnPressed: this.clickOverlayPageIndex,
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
