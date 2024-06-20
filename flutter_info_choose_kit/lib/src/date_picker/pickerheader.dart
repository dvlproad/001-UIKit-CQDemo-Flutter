/*
 * @Author: dvlproad
 * @Date: 2023-05-09 13:32:35
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-06-20 19:48:54
 * @Description: 
 */
import 'package:flutter/material.dart';

class PickerHeader extends StatefulWidget {
  final double? height;
  final String? title;
  final String cancelText;
  final String confirmText;
  final void Function()? onCancel;
  final void Function()? onConfirm;

  const PickerHeader({
    Key? key,
    this.height,
    this.title,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      padding: const EdgeInsets.only(left: 20, right: 20),
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
          style: const TextStyle(
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
          style: const TextStyle(
            color: Color(0xFFFF7F00),
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
          style: const TextStyle(
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
