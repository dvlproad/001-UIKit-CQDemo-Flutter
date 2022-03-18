import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show BJHTitleTextValueCell, TableViewCellArrowImageType;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './dev_branch_bean.dart';

class DevBranchCell extends StatefulWidget {
  final DevBranchBean devBranchBean;

  const DevBranchCell({
    Key key,
    this.devBranchBean,
  }) : super(key: key);

  @override
  _DevBranchCellState createState() => _DevBranchCellState();
}

class _DevBranchCellState extends State<DevBranchCell> {
  DevBranchBean _devBranchBean;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _devBranchBean = widget.devBranchBean;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            BJHTitleTextValueCell(
              height: 40,
              title: _devBranchBean.name,
              textValue: '',
              arrowImageType: TableViewCellArrowImageType.none,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          cellWidget(
                            title: "创建时间",
                            textValue: _devBranchBean.createTime,
                            textValueFontSize: 12,
                          ),
                          cellWidget(
                            title: "分支功能",
                            textValue: _devBranchBean.des,
                            textValueFontSize: 12,
                          ),
                          Container(height: 1, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  _arrowImage(),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        String fullVersionDes = _devBranchBean.toString();

        Clipboard.setData(ClipboardData(text: fullVersionDes));
        ToastUtil.showMessage('版本信息拷贝成功');
      },
      onLongPress: () {},
    );
  }

  Widget cellWidget({
    String title,
    String textValue,
    double textValueFontSize,
  }) {
    if (textValue == null || textValue.isEmpty) {
      textValue = '未标明';
    }
    // return BJHTitleTextValueCell(
    //   title: title,
    //   textValue: textValue,
    //   textValueFontSize: textValueFontSize ?? 12,
    // );

    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _mainText(title),
          Expanded(child: _textValueWidget(textValue)),
        ],
      ),
    );
  }

  // 主文本
  Widget _mainText(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        title ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xff222222),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textValueWidget(String textValue, {double textValueFontSize}) {
    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: const BoxConstraints(maxWidth: 180, minHeight: 30),
      color: Colors.transparent,
      child: Text(
        textValue ?? '',
        textAlign: TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xff999999),
          fontSize: textValueFontSize ?? 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 箭头
  Widget _arrowImage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: const Image(
        image:
            AssetImage('assets/arrow_right.png', package: 'flutter_baseui_kit'),
        width: 17,
        height: 32,
      ),
    );
  }
}
