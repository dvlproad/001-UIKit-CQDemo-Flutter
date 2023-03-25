import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show ImageTitleTextValueCell, TableViewCellArrowImageType;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show DevBranchBean;

import '../cell/title_value_cell.dart';

class DevBranchCell extends StatefulWidget {
  final DevBranchBean devBranchBean;
  final int branchIndex;

  const DevBranchCell({
    Key? key,
    required this.devBranchBean,
    required this.branchIndex,
  }) : super(key: key);

  @override
  _DevBranchCellState createState() => _DevBranchCellState();
}

class _DevBranchCellState extends State<DevBranchCell> {
  late DevBranchBean _devBranchBean;

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
            ImageTitleTextValueCell(
              constraints: BoxConstraints(minHeight: 30),
              title: "${widget.branchIndex + 1}.${_devBranchBean.name}",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              titleTimeClosedWidget(
                                title: "创建:",
                                textValue: _devBranchBean.createTime,
                              ),
                              titleTimeClosedWidget(
                                title: "提测:",
                                textValue: _devBranchBean.submitTestTime,
                              ),
                              titleTimeClosedWidget(
                                title: "通过:",
                                textValue: _devBranchBean.passTestTime,
                              ),
                              titleTimeClosedWidget(
                                title: "合入:",
                                textValue: _devBranchBean.mergerPreTime,
                              ),
                            ],
                          ),
                          TitleValueCellFactory.columnCellWidget(
                            title: "分支功能",
                            textValue: _devBranchBean.des,
                            textValueFontSize: 16,
                            textValueMaxLines: 50,
                          ),
                          Container(height: 1, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  TitleValueCellFactory.arrowImage(),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        String fullVersionDes = _devBranchBean.description;

        Clipboard.setData(ClipboardData(text: fullVersionDes));
        ToastUtil.showMessage('版本信息拷贝成功');
      },
      onLongPress: () {},
    );
  }

  Widget titleTimeClosedWidget({
    required String title,
    String? textValue,
    double? textValueFontSize,
  }) {
    if (textValue == null || textValue.isEmpty) {
      return Container(
        width: 20,
        height: 10,
        color: Color.fromARGB(255, Random.secure().nextInt(255),
            Random.secure().nextInt(255), Random.secure().nextInt(255)),
      );
    }

    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleValueCellFactory.mainText(title),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              textValue,
              textAlign: TextAlign.right,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xff333333),
                fontSize: textValueFontSize ?? 15,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
