import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show HistoryVersionBean, DevBranchBean;

import '../dev_branch/dev_branch_page.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import '../cell/title_value_cell.dart';

class HistoryVerisonCell extends StatefulWidget {
  final HistoryVersionBean historyVersionBean;

  const HistoryVerisonCell({
    Key? key,
    required this.historyVersionBean,
  }) : super(key: key);

  @override
  _HistoryVerisonCellState createState() => _HistoryVerisonCellState();
}

class _HistoryVerisonCellState extends State<HistoryVerisonCell> {
  late HistoryVersionBean _historyVersionBean;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _historyVersionBean = widget.historyVersionBean;
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
              title: 'V${_historyVersionBean.version}',
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
                            title: "上线时间",
                            textValue: _historyVersionBean.onlineTime,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.columnCellWidget(
                            title: "版本功能",
                            textValue: _historyVersionBean.getDescription(
                              showBranchName: false,
                            ),
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
      onLongPress: throttle(() async {
        String _brancesRecordTime = _historyVersionBean.onlineTime ?? '';
        List<DevBranchBean> _devBranchBeans =
            _historyVersionBean.onlineBrances ?? [];
        if (_devBranchBeans.isEmpty) {
          ToastUtil.showMessage('暂无分支信息');
          return;
        }

        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DevBranchPage(
            brancesRecordTime: _brancesRecordTime,
            devBranchBeans: _devBranchBeans,
          );
        }));
      }),
      onTap: throttle(() async {
        String fullVersionDes = _historyVersionBean.getDescription(
          showBranchName: false,
        );

        Clipboard.setData(ClipboardData(text: fullVersionDes));
        ToastUtil.showMessage('版本信息拷贝成功');
      }),
    );
  }
}
