import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_base_page.dart';

class GuideOverlayPage3 extends StatelessWidget {
  @required
  final VoidCallback iKnowOnPressed;

  const GuideOverlayPage3({Key key, this.iKnowOnPressed}) : super(key: key);

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
                      'lib/modules/guide/Resources/pic_用户引导_上滑动.png'),
                  width: 70,
                  height: 270,
                ),
                string: '上滑',
                effect: '唤出评论页',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
