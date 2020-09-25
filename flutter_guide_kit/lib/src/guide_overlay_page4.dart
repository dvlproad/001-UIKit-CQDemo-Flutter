import 'package:flutter/material.dart';
import './guide_overlay_base_page.dart';

class GuideOverlayPage4 extends StatelessWidget {
  @required
  final VoidCallback iKnowOnPressed;
  final VoidCallback backgroundOnPressed;

  const GuideOverlayPage4({
    Key key,
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GuideOverlayFlag(
                image: Image(
                  image: AssetImage(
                    'assets/guideoverlay_event_movedown.png',
                    package: 'flutter_guide_kit',
                  ),
                  width: 70,
                  height: 270,
                ),
                string: '下滑',
                effect: '退出合集到首页',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
