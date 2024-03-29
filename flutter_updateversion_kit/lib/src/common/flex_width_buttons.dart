/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-08 13:24:18
 * @Description: 
 */
import 'package:flutter/material.dart';

/*
 * 等宽均分的 Buttons
 */
class FlexWidthButtons extends StatelessWidget {
  final double? height;
  final List<String> titles;
  final void Function(int buttonIndex) onPressed;

  const FlexWidthButtons({
    Key? key,
    this.height,
    required this.titles,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height ?? 50,
      child: Stack(
        children: <Widget>[
          const Divider(color: Colors.grey, height: 1),
          Container(child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    List<Widget> rowWidgets = [];
    int count = titles.length;
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
      child: TextButton(
        // shape: StadiumBorder(side: BorderSide(color: Colors.black)),
        onPressed: () {
          onPressed(index);
        },
        child: Text(
          titles[index],
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 15.0),
        ),
      ),
    );
  }
}
