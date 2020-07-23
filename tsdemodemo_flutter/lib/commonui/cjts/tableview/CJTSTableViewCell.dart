import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ClickCellCallback = void Function(int section, int row);

class CJTSTableViewCell extends StatefulWidget {
  final String title;
  final int section;
  final int row;
//  final GestureTapCallback onTap;
  final ClickCellCallback clickCellCallback;

  CJTSTableViewCell({Key key, this.title, this.section, this.row, this.clickCellCallback}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _CJTSTableViewCellState();
  }
}

class _CJTSTableViewCellState extends State<CJTSTableViewCell> {
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
    widget.clickCellCallback(widget.section, widget.row);
  }

  Widget _cellContainer() {
    return Container(
      height: 44,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
            color: Colors.transparent,
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
            color: Colors.transparent,
            child: Image(
              image: AssetImage('lib/Resources/report/arrow_right.png'),
              width: 8,
              height: 12,
            ),
          )
        ],
      ),
    );
  }
}
