import 'package:flutter/material.dart';

class PickerHeader extends StatefulWidget {
  final double height;
  final String title;
  final String cancelText;
  final String confirmText;
  final void Function() onCancel;
  final void Function() onConfirm;

  PickerHeader({
    Key key,
    this.height,
    this.title,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  _PickerHeaderState createState() => _PickerHeaderState();
}

class _PickerHeaderState extends State<PickerHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _cancelWidget,
          _titleWidget,
          _confirmWidget,
        ],
      ),
    );
  }

  Widget get _cancelWidget {
    return GestureDetector(
      onTap: widget.onCancel,
      child: Center(
        child: Text(
          widget.cancelText,
          style: TextStyle(
            color: Color(0xFF999999),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget get _confirmWidget {
    return GestureDetector(
      onTap: widget.onConfirm,
      child: Center(
        child: Text(
          widget.confirmText,
          style: TextStyle(
            color: Color(0xFFCD3F49),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget get _titleWidget {
    return Expanded(
      child: Center(
        child: Text(
          widget.title ?? '',
          style: TextStyle(
            color: Color(0xFF222222),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
