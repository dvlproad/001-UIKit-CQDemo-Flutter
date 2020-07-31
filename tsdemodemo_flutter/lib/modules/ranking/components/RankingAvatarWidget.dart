import 'package:flutter/cupertino.dart';
import 'package:tsdemodemo_flutter/modules/user_avatar_widget.dart';
import 'package:tsdemodemo_flutter/modules/user_bean.dart';

class RankingAvatarWidget extends StatelessWidget {
  final int rankingNumber;
  final UserBean userBean;
  final double radius;
  final double strokeWidth;

  const RankingAvatarWidget(
      {Key key,
      @required this.rankingNumber,
      @required this.userBean,
      @required this.radius,
      this.strokeWidth = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rankingFlagImageWidth = 14;
    double rankingFlagImageHeight = 12;
    String rankingFlagImageName = 'lib/Resources/ranking/icon_no2.png';
    if (rankingNumber == 1) {
      rankingFlagImageWidth = 20;
      rankingFlagImageHeight = 18;
      rankingFlagImageName = 'lib/Resources/ranking/icon_no1.png';
    }

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 3),
            AvatarWidget(
              userBean: userBean,
              radius: radius,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
        Positioned(
          right: 8,
          child: Image(
            image: AssetImage(rankingFlagImageName),
            width: rankingFlagImageWidth,
            height: rankingFlagImageHeight,
          ),
        )
      ],
    );
  }
}
