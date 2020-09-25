import 'package:flutter/material.dart';
import './guide_overlay_base_page.dart';

class GuideOverlayPage5 extends StatelessWidget {
  @required
  final VoidCallback iKnowOnPressed;
  final VoidCallback backgroundOnPressed;

  const GuideOverlayPage5({
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
                    'assets/guideoverlay_event_longpress.png',
                    package: 'flutter_guide_kit',
                  ),
                  width: 80,
                  height: 80,
                ),
                string: '试试长按',
                effect: '进入无UI模式',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
