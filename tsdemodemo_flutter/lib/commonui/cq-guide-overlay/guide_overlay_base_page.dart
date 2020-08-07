/// 引导页通用部分：背景+'我知道了'按钮
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textbutton.dart';

typedef ClickOverlayPageBGCallback = void Function();
typedef ClickOverlayPageIKnowCallback = void Function();

class GuideOverlayBasePage extends StatelessWidget {
  final ClickOverlayPageBGCallback clickOverlayPageBGCallback;
  final ClickOverlayPageIKnowCallback clickOverlayPageIKnowCallback;
  final Widget overlayChild;

  GuideOverlayBasePage({
    Key key,
    this.overlayChild,
    this.clickOverlayPageBGCallback,
    this.clickOverlayPageIKnowCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      color: Colors.black.withOpacity(0.4),
      child: GestureDetector(
        onTap: this.clickOverlayPageBGCallback,
        child: Stack(
          children: <Widget>[
            this.overlayChild,
            Positioned(
              left: 40,
              right: 40,
              bottom: 30,
              child: Container(
                height: 42,
                child: WhiteThemeBGButton(
                  text: "我知道了",
                  onPressed: this.clickOverlayPageIKnowCallback,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 引导页的操作小组件
class GuideOverlayFlag extends StatelessWidget {
  final Image image; // 操作指示图片
  final String string; // 操作描述(如'点击')
  final String effect; // 操作效果(如'上一个合集')

  GuideOverlayFlag({Key key, this.string, this.effect, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image,
        SizedBox(height: 10),
        Text(
          this.string,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black12,
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(height: 10),
        Text(
          this.effect,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}

// class GuideOverlayStepText1 extends StatelessWidget {
//   final String text;
//   const GuideOverlayStepText1(this.text, {Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(
//         this.text,
//         style: TextStyle(fontSize: 14, color: Colors.black12),
//       ),
//     );
//   }
// }

// class GuideOverlayStepText2 extends StatelessWidget {
//   final String text;
//   const GuideOverlayStepText2(this.text, {Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(
//         this.text,
//         style: TextStyle(fontSize: 16, color: Colors.black),
//       ),
//     );
//   }
// }
