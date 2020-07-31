import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/RankingAvatarWidget.dart';
import 'package:tsdemodemo_flutter/modules/ranking/rankling_bean.dart';

class RankingListHeader extends StatelessWidget {
  final List<RanklingRowBean> topThereBeans;

  RankingListHeader({Key key, this.topThereBeans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _topWidget();
  }

  Widget _topWidget() {
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        verticalDirection: VerticalDirection.down, //子child的垂直布局方向，向上还是向下
        children: <Widget>[
          Expanded(
            flex: 100,
            child: Container(
              color: Colors.transparent,
              height: 170,
              child: _oneRankCell(2, this.topThereBeans[1]),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 115,
            child: Container(
              color: Colors.transparent,
              height: 200,
              child: _oneRankCell(1, this.topThereBeans[0]),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 100,
            child: Container(
              color: Colors.transparent,
              height: 170,
              child: _oneRankCell(3, this.topThereBeans[2]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneRankCell(rankingNumber, rankingRowBean) {
    double imageSize = 60;
    double fontSize = 14;
    String borderImageName = 'lib/Resources/ranking/frame_no2.png';
    if (rankingNumber == 1) {
      imageSize = 80;
      fontSize = 16;
      borderImageName = 'lib/Resources/ranking/frame_no1.png';
    }
    ImageProvider borderImage = AssetImage(borderImageName); // 本地图片
    //ImageProvider borderImage = NetworkImage('https://avatar.csdn.net/8/9/A/3_chenlove1.jpg'); // 网络图片

    String _influenceString = rankingRowBean.influenceString;

    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: borderImage,
          fit: BoxFit.fill,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 6),
            RankingAvatarWidget(
                rankingNumber: rankingNumber,
                userBean: rankingRowBean.user,
                radius: imageSize / 2),
            Text(rankingRowBean.user.nickName,
                style: TextStyle(color: Color(0xFFC4C4C4), fontSize: fontSize)),
            SizedBox(height: 28),
            Text('影响力',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 2),
            Text(_influenceString,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18)),
            SizedBox(height: 6),
          ],
        ));
  }
}
