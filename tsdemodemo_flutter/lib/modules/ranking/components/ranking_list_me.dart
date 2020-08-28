import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/ranking/rankling_bean.dart';
import 'package:tsdemodemo_flutter/modules/user_avatar_widget.dart';

typedef ClickCellCallback = void Function(int section, int row);

/// 排行榜底部我的排名视图
class RankingListBottom extends StatelessWidget {
  final bool showIndex; // 是否显示编号
  final RanklingMeBean dataBean; // 数据

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback; // cell 的点击

  RankingListBottom({
    Key key,
    this.showIndex = true,
    @required this.dataBean,
    this.section,
    this.row,
    this.clickCellCallback,
  }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _RankingListBottomState();
//   }
// }
//
// class _RankingListBottomState extends State<RankingListBottom> {
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
    if (null != this.clickCellCallback) {
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
        ));
  }

  // Cell 的左侧视图
  Widget _leftRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        showIndex ? _indexText() : Container(),
        SizedBox(width: 16),
        AvatarWidget(userBean: dataBean.user, radius: 30),
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
        (4 + row).toString(),
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
//    if(dataModel == null) {
//      dataModel = RankingBean();
//    }

    String _userName = dataBean.user.nickName ?? ''; //用户名
    // String _avatar = dataBean.user.avatar ?? '';    // 头像
    int _rankNumber = dataBean.number; // 排名

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
              child: Text('排名 ' + _rankNumber.toString(),
                  style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 12)),
            ),
          ],
        )
      ],
    );
  }

  // 影响力
  Widget _influenceWidget() {
    String _influenceString = dataBean.influenceString;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('影响力',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 2),
        Text(_influenceString,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
      ],
    );
  }
}
