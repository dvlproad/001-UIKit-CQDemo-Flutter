import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import './bottomwidget.dart';

class ItemPickerWidget extends StatefulWidget {
  final String title;
  final void Function() onCancel;
  final void Function(int selectedIndex) onConfirm;

  final List<String> itemTitles;
  final int currentSelectedIndex;
  final void Function(int selectedIndex) onItemTap;

  ItemPickerWidget({
    Key key,
    this.title,
    this.onCancel,
    @required this.onConfirm,
    @required this.itemTitles,
    this.onItemTap,
    this.currentSelectedIndex = 0,
  }) : super(key: key);

  @override
  _ItemPickerWidgetState createState() => _ItemPickerWidgetState();
}

class _ItemPickerWidgetState extends State<ItemPickerWidget> {
  double itemExtent = 40;
  double extralHeight = 30; // 为了让滚轮能显示，额外自己添加的高度

  int _selectedIndex;
  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.currentSelectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double itemWidgetsHeight = widget.itemTitles.length * itemExtent;

    return BottomWidget(
      title: widget.title,
      middleContentWidget: _itemsWidget_useList,
      middleContentWidgetHeight: itemWidgetsHeight,
      onCancel: widget.onCancel,
      // onConfirm: () {
      //   if (widget.onConfirm != null) {
      //     widget.onConfirm(_selectedIndex);
      //   }
      // },
    );
  }

  Widget get _itemsWidget_userPicker {
    List<Widget> itemWidgets = [];
    int count = widget.itemTitles.length;
    for (int i = 0; i < count; i++) {
      Widget itemWidget = _createItem(i);
      itemWidgets.add(itemWidget);
    }

    return CupertinoPicker(
      diameterRatio: 1,
      itemExtent: itemExtent,
      selectionOverlay: Container(
        height: itemExtent,
        decoration: const BoxDecoration(
          color: Color(0x20FF4587),
        ),
      ),
      onSelectedItemChanged: (position) {
        setState(() {
          _selectedIndex = position;
        });
      },
      children: itemWidgets,
    );
  }

  Widget get _itemsWidget_useList {
    return ListView.builder(
      padding: EdgeInsets.zero, // 保证可以滚回
      itemCount: widget.itemTitles.length,
      itemExtent: itemExtent,
      itemBuilder: (BuildContext context, int index) {
        return _createItem(index);
      },
    );
  }

  Widget _createItem(int index) {
    String title = widget.itemTitles[index];
    return CJStateTextButton(
      normalTitle: title ?? "",
      onPressed: () {
        if (widget.onItemTap != null) {
          widget.onItemTap(index);
        }
      },
    );

    /* // 点击没有高亮等效果
    return GestureDetector(
      onTap: () {
        if (widget.onItemTap != null) {
          widget.onItemTap(index);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            title ?? "",
            style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'PingFang SC',
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    */
  }
}

class CJStateTextButton extends StatelessWidget {
  final String normalTitle;
  final VoidCallback onPressed;
  final bool enable;
  final double disableOpacity;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color normalBorderColor;
  final double normalBorderWidth;
  final Color normalHighlightColor;

  CJStateTextButton({
    Key key,
    @required this.normalTitle,
    @required this.onPressed,
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.cornerRadius = 5.0,
    this.normalBGColor,
    this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.normalHighlightColor,
  })  : assert(normalTitle != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String _currentTitle;
    Color _currentTextColor;
    Color _currentBackgroundColor;
    Color _highlightColor;

    Color _currentBorderColor;
    double _currentBorderWidth;
    double _cornerRadius = this.cornerRadius;

    _currentTitle = normalTitle;

    if (enable) {
      _currentTextColor = normalTextColor;
      _currentBackgroundColor = normalBGColor;
      _currentBorderColor = normalBorderColor ?? Colors.transparent;
      _highlightColor = normalHighlightColor;
    } else {
      _currentTextColor = normalTextColor.withOpacity(disableOpacity);
      _currentBackgroundColor = normalBGColor.withOpacity(disableOpacity);
      _currentBorderColor = normalBorderColor != null
          ? normalBorderColor.withOpacity(disableOpacity)
          : Colors.transparent;
    }

    _currentBorderWidth = normalBorderWidth;

    VoidCallback _onPressed;
    if (this.enable) {
      _onPressed =
          this.onPressed ?? () {}; // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
    } else {
      _onPressed = null; // 这里是用 onPressed 的是否为空，来内部设置 enable 属性的
    }

    return Container(
      child: TextButton(
        child: Text(
          _currentTitle,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF222222),
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: _onPressed,
        style: ButtonStyle(
          //背景颜色
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              //设置按下时的背景颜色
              if (states.contains(MaterialState.pressed)) {
                return Color(0xFFFF7F00).withOpacity(0.12);
              }
              //默认不使用背景颜色
              return _currentBackgroundColor;
            },
          ),
          shape: MaterialStateProperty.resolveWith(
            (states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_cornerRadius),
                side: BorderSide(
                  width: _currentBorderWidth,
                  color: _currentBorderColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
