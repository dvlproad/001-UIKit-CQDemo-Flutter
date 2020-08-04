import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_base_page.dart';

class GuideOverlayPage6 extends StatelessWidget {
  final double right1;
  final double bottom1;
  final double right2;
  final double bottom2;

  @required
  final VoidCallback iKnowOnPressed;

  const GuideOverlayPage6(
      {Key key,
      this.right1 = 20,
      this.bottom1 = 80,
      this.right2 = 0,
      this.bottom2 = 20,
      this.iKnowOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlayPage(
      overlayChild: overlayChild(),
      clickOverlayPageCallback: iKnowOnPressed,
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
                Positioned(
                  left: this.right1,
                  top: this.bottom1,
                  child: Image(
                    image:
                        AssetImage('lib/modules/guide/Resources/pic_按钮引导.png'),
                    width: 70,
                    height: 56,
                  ),
                ),
                Positioned(
                  right: this.right2,
                  bottom: this.bottom2,
                  child: Image(
                    image: AssetImage(
                        'lib/modules/guide/Resources/pic_用户引导_按钮引导.png'),
                    width: 70,
                    height: 56,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
