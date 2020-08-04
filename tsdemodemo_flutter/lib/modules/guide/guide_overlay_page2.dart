import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_base_page.dart';

class GuideOverlayPage2 extends StatelessWidget {
  @required
  final VoidCallback iKnowOnPressed;

  const GuideOverlayPage2({Key key, this.iKnowOnPressed}) : super(key: key);

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
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GuideOverlayFlag(
                image: Image(
                  image: AssetImage(
                      'lib/modules/guide/Resources/pic_用户引导_左滑动.png'),
                  width: 270,
                  height: 70,
                ),
                string: '左滑',
                effect: '进入下一个合集',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
