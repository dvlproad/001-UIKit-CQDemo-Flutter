import 'package:flutter/material.dart';

/*
 * 等宽均分的 Buttons
 */
class FlexWidthButtons extends StatelessWidget {
  final double height;
  final List<String> titles;
  final void Function(int buttonIndex) onPressed;

  FlexWidthButtons({
    Key key,
    this.height,
    @required this.titles,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: this.height ?? 50,
      child: Stack(
        children: <Widget>[
          Divider(color: Colors.grey, height: 1),
          Container(child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    List<Widget> rowWidgets = [];
    int count = this.titles.length;
    for (var i = 0; i < count; i++) {
      rowWidgets.add(_button(i));
      if (i != count - 1) {
        rowWidgets.add(
          VerticalDivider(
            color: Colors.grey[300],
            width: 1,
            thickness: 1,
          ),
        );
      }
    }

    return Row(
      children: rowWidgets,
    );
  }

  Widget _button(int index) {
    return Expanded(
      flex: 1,
      child: FlatButton(
        color: Colors.transparent,
        // shape: StadiumBorder(side: BorderSide(color: Colors.black)),
        onPressed: () {
          if (this.onPressed != null) {
            this.onPressed(index);
          }
        },
        child: Text(
          this.titles[index],
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 15.0),
        ),
      ),
    );
  }
}
