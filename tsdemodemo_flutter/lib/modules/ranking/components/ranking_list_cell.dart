// 包含主文本main，且可选定制副文本、箭头 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/ranking/rankling_bean.dart';
import 'package:tsdemodemo_flutter/modules/user_avatar_widget.dart';

typedef ClickCellCallback = void Function(int section, int row);

enum RankingListCellArrowImageType{
  none,           // 无箭头
  arrowRight,     // 右箭头
  arrowTopBottom, // 上下箭头
}

/// 排行榜Cell
class RankingListCell extends StatelessWidget {
  final bool showIndex;                       // 是否显示编号
  //final Map<String, dynamic> dataMap;       // 数据
  final RanklingRowBean dataModel;                // 数据
  final RankingListCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback;  // cell 的点击

  RankingListCell({
    Key key,
    this.showIndex = true,
    //this.dataMap,
    @required this.dataModel,
    this.arrowImageType=RankingListCellArrowImageType.none,

    this.section,
    this.row,
    this.clickCellCallback,
  }) : super(key: key);


//   @override
//   State<StatefulWidget> createState() {
//     return _RankingListCellState();
//   }
// }
//
// class _RankingListCellState extends State<RankingListCell> {
  @override
  Widget build(BuildContext context) {
    return cellWidget();
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if(null != this.clickCellCallback) {
      this.clickCellCallback(this.section, this.row);
    }
  }


  Widget _cellContainer() {
    return Container(
      height: 90,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           _leftRow(),
          _rightRow(),
        ],
      )
    );
  }

  // Cell 的左侧视图
  Widget _leftRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showIndex ? _indexText() : Container(),
        SizedBox(width: 16),
        AvatarWidget(userBean: dataModel.user, radius: 30),
        SizedBox(width: 8),
        _fansWidget(),
      ],
    );
  }

  // Cell 的右侧视图
  Widget _rightRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _influenceWidget(),
        SizedBox(width: 10),
      ],
    );
  }


  // 标号
  Widget _indexText() {
    return Container(
      color: Colors.transparent,
      child: Text(
        (4+row).toString(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  // 粉丝数
  Widget _fansWidget() {
    String _userName = dataModel.user.nickName;          //用户名
    int _fansCount = dataModel.fansCount;           //粉丝数
    int _followerCount = dataModel.followerCount;   //关注数
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_userName, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 6),
        Row(
          children: <Widget>[
            Container(
              width: 70,
              child: Text('粉丝数 ' + _fansCount.toString(), style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 12)),
            ),
            SizedBox(width: 4),
            Text('关注 ' + _followerCount.toString(), style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 12)),
          ],
        )
      ],
    );
  }

  // 影响力
  Widget _influenceWidget() {
    String _influenceString = dataModel.influenceString;  //影响力
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('影响力', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 2),
        Text(_influenceString, textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
      ],
    );
  }
}
