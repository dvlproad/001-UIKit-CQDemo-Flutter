import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EnvironmentTableViewHeader extends StatefulWidget {
  final String title;

  EnvironmentTableViewHeader({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnvironmentTableViewHeaderState();
  }
}

class _EnvironmentTableViewHeaderState
    extends State<EnvironmentTableViewHeader> {
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
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      // color: Colors.green,
      alignment: Alignment.centerLeft,
      height: 40,
      child: Row(
        children: [
          Center(
            child: Text(
              widget.title,
              // textAlign: TextAlign.right,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
