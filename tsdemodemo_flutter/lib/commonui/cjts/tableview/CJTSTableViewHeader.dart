import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CJTSTableViewHeader extends StatefulWidget {
  final String title;

  CJTSTableViewHeader({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CJTSTableViewHeaderState();
  }
}

class _CJTSTableViewHeaderState extends State<CJTSTableViewHeader> {
  @override
  Widget build(BuildContext context) {
    return headerWidget();
  }

  Widget headerWidget() {
//    return GestureDetector(
//      child: _headerContainer(),
//      onTap: _onTapHeader,
//    );
    return _headerContainer();
  }

  Widget _headerContainer() {
    return Container(
      height: 44,
      color: Colors.black,
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
      ),
    );
  }
}
