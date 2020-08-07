import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_base_page.dart';
import 'package:tsdemodemo_flutter/commonui/cq-line/cq-dotted-line.dart';

class GuideOverlayPage1 extends StatelessWidget {
  @required
  final VoidCallback iKnowOnPressed;
  final VoidCallback backgroundOnPressed;

  const GuideOverlayPage1({
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
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GuideOverlayFlag(
                  image: Image(
                    image: AssetImage(
                        'lib/commonui/cq-guide-overlay/Resources/pic_用户引导_点击.png'),
                    width: 80,
                    height: 80,
                  ),
                  string: '点击',
                  effect: '上一个合集',
                ),
              ),
              _dottedLine(),
              Expanded(
                flex: 2,
                child: Container(),
              ),
              _dottedLine(),
              Expanded(
                flex: 1,
                child: GuideOverlayFlag(
                  image: Image(
                    image: AssetImage(
                        'lib/commonui/cq-guide-overlay/Resources/pic_用户引导_点击.png'),
                    width: 80,
                    height: 80,
                  ),
                  string: '点击',
                  effect: '下一个合集',
                ),
              ),
            ],
          ),
          // Positioned(
          //   left: 40,
          //   right: 40,
          //   bottom: 20,
          //   child:
          //       WhiteThemeBGButton(text: "我知道了", onPressed: this.iKnowOnPressed),
          // ),
        ],
      ),
    );
  }

  DottedLineWidget _dottedLine() {
    return DottedLineWidget(
      axis: Axis.vertical,
      color: Colors.white,
      lineHeight: 5,
      lineWidth: 0.5,
      count: 80,
    );
  }
}
