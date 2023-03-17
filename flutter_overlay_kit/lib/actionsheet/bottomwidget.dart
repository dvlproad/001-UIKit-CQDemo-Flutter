import 'package:flutter/material.dart';
import './components/actionsheet_header.dart';
import './components/actionsheet_footer.dart';

class BottomWidget extends StatefulWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final void Function()? onCancel;
  final void Function()? onConfirm; // 需要确认操作(需要时候，取消按钮和确认按钮都在顶部；不需要时候，取消按钮在底部)

  final Widget middleContentWidget;
  final double middleContentWidgetHeight;

  BottomWidget({
    Key? key,
    this.title,
    this.titleTextStyle,
    this.onCancel,
    this.onConfirm,
    required this.middleContentWidget,
    required this.middleContentWidgetHeight,
  }) : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  double headerHeight = 60;

  double itemExtent = 40;
  double extralHeight = 30; // 为了让滚轮能显示，额外自己添加的高度

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnWidgets = [];
    double columnWidgetsHeight = 0;

    bool needConfirmAction = widget.onConfirm != null;

    Widget headerWidget = PickerHeader(
      height: headerHeight,
      title: widget.title,
      titleTextStyle: widget.titleTextStyle,
      cancelText: needConfirmAction ? '取消' : '',
      confirmText: needConfirmAction ? '确定' : '',
      onCancel: widget.onCancel,
      onConfirm: () {
        if (widget.onConfirm != null) {
          widget.onConfirm!();
        }
      },
    );
    columnWidgets.add(headerWidget);
    columnWidgetsHeight += headerHeight;

    Widget middleWidget = Container(
      // width: Adapt.screenW(),
      height: widget.middleContentWidgetHeight,
      alignment: Alignment.center,
      child: widget.middleContentWidget,
    );
    columnWidgets.add(middleWidget);
    columnWidgetsHeight += widget.middleContentWidgetHeight;

    if (needConfirmAction == false) {
      PickerFooter footerWidget = PickerFooter(
        cancelText: '取消',
        onCancel: () {
          if (widget.onCancel != null) {
            widget.onCancel!();
          }
        },
      );
      columnWidgets.add(footerWidget);
      columnWidgetsHeight += footerWidget.createState().getSelfViewHeight();
    }

    BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(14.0),
      topRight: Radius.circular(14.0),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: columnWidgetsHeight,
        color: Colors.white,
        child: Column(
          children: columnWidgets,
        ),
      ),
    );
  }
}
