/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 17:46:58
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer_new/flutter_json_viewer.dart';

import '../log_base_cell.dart';
import '../../bean/log_data_bean.dart';

class ApiLogDetailCell extends StatefulWidget {
  final int? maxLines;

  final LogModel apiLogModel; // 环境

  final int section;
  final int row;
  final void Function({
    required BuildContext context,
    int? section,
    int? row,
    required LogModel bLogModel,
  }) clickApiLogCellCallback; // logCell 的点击
  final void Function()? onLongPress;
  final void Function(dynamic) jsonViewOnTap;
  final void Function(dynamic) jsonViewOnDoubleTap;
  final void Function(dynamic) jsonViewOnLongPress;

  const ApiLogDetailCell({
    Key? key,
    this.maxLines,
    required this.apiLogModel,
    this.section = 0,
    this.row = 0,
    required this.clickApiLogCellCallback,
    this.onLongPress,
    required this.jsonViewOnTap,
    required this.jsonViewOnDoubleTap,
    required this.jsonViewOnLongPress,
  }) : super(key: key);

  @override
  State<ApiLogDetailCell> createState() => _ApiLogDetailCellState();
}

class _ApiLogDetailCellState extends State<ApiLogDetailCell> {
  late LogModel apiLogModel;
  bool _showJsonView = false;

  @override
  void initState() {
    super.initState();

    apiLogModel = widget.apiLogModel;
  }

  @override
  Widget build(BuildContext context) {
    Color subTitleColor = apiLogModel.logColor;

    String mainTitle = apiLogModel.title ?? '';
    String logHeaderTitle = '';

    if (apiLogModel.logType == LogObjectType.api_app ||
        apiLogModel.logType == LogObjectType.api_buriedPoint) {
      if (apiLogModel.extraLogInfo != null) {
        Map<dynamic, dynamic> extraLogInfo =
            apiLogModel.extraLogInfo!; // log 的 额外信息
        logHeaderTitle = extraLogInfo["logHeaderTitle"];
      }
    }

    Map<dynamic, dynamic> jsonMap = apiLogModel.detailLogModel;
    String jsonMapString = apiLogModel.detailMapString;

    return Column(
      children: [
        _buildButton(
          _showJsonView ? '切为文本展示\n(当前双击可复制)' : '切为图展示\n(当前单击可复制)',
          onPressed: () {
            _showJsonView = !_showJsonView;
            setState(() {});
          },
        ),
        _showJsonView
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogBaseTableViewCell(
                    maxLines: widget.maxLines ?? 18,
                    mainTitle: mainTitle,
                    subTitles: [logHeaderTitle],
                    subTitleColor: subTitleColor,
                    check: false,
                    section: widget.section,
                    row: widget.row,
                    clickEnvBaseCellCallback: ({
                      int? section,
                      int? row,
                      required String mainTitle,
                      List<String>? subTitles,
                      bool? check,
                    }) {
                      widget.clickApiLogCellCallback(
                        context: context,
                        section: widget.section,
                        row: widget.row,
                        bLogModel: apiLogModel,
                      );
                    },
                    onLongPress: widget.onLongPress,
                  ),
                  BaseJsonViewer(
                    jsonMap,
                    onTap: widget.jsonViewOnTap,
                    onDoubleTap: widget.jsonViewOnDoubleTap,
                    onLongPress: widget.jsonViewOnLongPress,
                  ),
                ],
              )
            : LogBaseTableViewCell(
                maxLines: widget.maxLines ?? 18,
                mainTitle: mainTitle,
                subTitles: [logHeaderTitle, jsonMapString],
                subTitleColor: subTitleColor,
                check: false,
                section: widget.section,
                row: widget.row,
                clickEnvBaseCellCallback: ({
                  int? section,
                  int? row,
                  required String mainTitle,
                  List<String>? subTitles,
                  bool? check,
                }) {
                  widget.clickApiLogCellCallback(
                    context: context,
                    section: widget.section,
                    row: widget.row,
                    bLogModel: apiLogModel,
                  );
                },
                onLongPress: widget.onLongPress,
              ),
      ],
    );
  }

  Widget _buildButton(
    String text, {
    required void Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        color: Colors.pink,
        width: 260,
        height: 50,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
