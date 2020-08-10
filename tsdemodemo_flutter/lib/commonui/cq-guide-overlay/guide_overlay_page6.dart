import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_base_page.dart';

class GuideOverlayPage6 extends StatelessWidget {
  final bool show1;
  final double right1;
  final double top1;
  @required
  final double height1;

  final bool show2;
  final double right2;
  final double top2;
  @required
  final double height2;

  @required
  final VoidCallback iKnowOnPressed;
  final VoidCallback backgroundOnPressed;

  const GuideOverlayPage6({
    Key key,
    this.show1 = false,
    this.right1 = 20,
    this.top1 = 80,
    this.height1 = 56,
    this.show2 = false,
    this.right2 = 0,
    this.top2 = 20,
    this.height2 = 56,
    this.iKnowOnPressed,
    this.backgroundOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GuideOverlayBasePage(
      overlayChild: overlayChild(),
      clickOverlayPageBGCallback: backgroundOnPressed,
      clickOverlayPageIKnowCallback: iKnowOnPressed,
    );
  }

  Widget overlayChild() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                _likeButtonGuideOverlay(),
                _photoButtonGuideOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _likeButtonGuideOverlay() {
    if (this.show1) {
      return Positioned(
        right: this.right1,
        top: this.top1,
        child: Image(
          image: AssetImage(
              'lib/commonui/cq-guide-overlay/Resources/pic_按钮引导_上.png'),
          width: 201 / 56 * this.height1,
          height: this.height1,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _photoButtonGuideOverlay() {
    if (this.show2) {
      return Positioned(
        right: this.right2,
        top: this.top2,
        child: Image(
          image: AssetImage(
              'lib/commonui/cq-guide-overlay/Resources/pic_按钮引导_下.png'),
          width: 137 / 56 * this.height2,
          height: this.height2,
        ),
      );
    } else {
      return Container();
    }
  }
}
