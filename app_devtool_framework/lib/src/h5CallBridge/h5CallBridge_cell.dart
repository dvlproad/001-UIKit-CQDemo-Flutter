import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import './h5js_model.dart';
import '../cell/title_value_cell.dart';

class H5CallBridgeCell extends StatefulWidget {
  final H5CallBridgeModel h5CallBridgeModel;
  final GestureTapCallback? onTap;

  const H5CallBridgeCell({
    Key? key,
    required this.h5CallBridgeModel,
    this.onTap,
  }) : super(key: key);

  @override
  _H5CallBridgeCellState createState() => _H5CallBridgeCellState();
}

class _H5CallBridgeCellState extends State<H5CallBridgeCell> {
  late H5CallBridgeModel _h5CallBridgeModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _h5CallBridgeModel = widget.h5CallBridgeModel;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ImageTitleTextValueCell(
              constraints: const BoxConstraints(minHeight: 30),
              title: _h5CallBridgeModel.actionName,
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
                          TitleValueCellFactory.rowCellWidget(
                            title: "方法描述",
                            textValue: _h5CallBridgeModel.actionDes,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.columnCellWidget(
                            title: "方法详情",
                            textValue: _h5CallBridgeModel.description,
                            textValueFontSize: 16,
                            textValueMaxLines: 100,
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
      onTap: throttle(() async {
        if (widget.onTap != null) {
          widget.onTap!();
        }
        /*
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DevBranchPage(
            brancesRecordTime: _brancesRecordTime,
            devBranchBeans: _devBranchBeans,
          );
        }));
        */
      }),
      onLongPress: throttle(() async {
        String fullVersionDes = _h5CallBridgeModel.description;

        Clipboard.setData(ClipboardData(text: fullVersionDes));
        ToastUtil.showMessage('版本信息拷贝成功');
      }),
    );
  }
}
