import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/round_image.dart';

class RankingListTop extends StatelessWidget {
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
        verticalDirection: VerticalDirection.down,  //子child的垂直布局方向，向上还是向下
        children: <Widget>[
          Expanded(
            flex: 100,
            child: Container(
              color: Colors.transparent,
              height: 170,
              child: _oneRankCell(2),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 115,
            child: Container(
              color: Colors.transparent,
              height: 200,
              child: _oneRankCell(1),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 100,
            child: Container(
              color: Colors.transparent,
              height: 170,
              child: _oneRankCell(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oneRankCell(rankingNumber) {
    double imageSize = 60;
    double fontSize = 14;
    if (rankingNumber == 1) {
      imageSize = 80;
      fontSize = 16;
    }

    return Container(
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(17),///圆角
//            border: Border.all(color: Colors.green, width: 1)///边框颜色、宽
//        ),
        decoration: BoxDecoration(
            border: new Border.all(color: Color(0xFFFFFF00), width: 1.0), // 边色与边宽度
            borderRadius: BorderRadius.circular(6),
            image: new DecorationImage(
                image: new NetworkImage('https://avatar.csdn.net/8/9/A/3_chenlove1.jpg'), // 网络图片
                // image: new AssetImage('graphics/background.png'), 本地图片
                fit: BoxFit.fill // 填满
              //centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),// 固定大小
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 6),
            RoundImage(size: imageSize, networkSrc: 'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg'),
            Text('豚骨拉面v', style: TextStyle(color: Color(0xFFC4C4C4), fontSize: fontSize)),
            SizedBox(height: 30),
            Text('影响力', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 2),
            Text('1057.7w', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18)),
            SizedBox(height: 6),
          ],
        )
    );
  }

}