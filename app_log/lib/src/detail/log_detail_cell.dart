/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-28 15:28:25
 * @Description: 
 */
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_log/src/log/log_base_cell.dart';
import 'package:flutter_network/flutter_network.dart';

import 'package:flutter_json_viewer/flutter_json_viewer.dart';

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

  ApiLogDetailCell({
    Key? key,
    this.maxLines,
    required this.apiLogModel,
    this.section = 0,
    this.row = 0,
    required this.clickApiLogCellCallback,
    this.onLongPress,
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
    Color subTitleColor = Colors.black;
    if (apiLogModel.logLevel == LogLevel.error) {
      subTitleColor = Colors.red;
    } else if (apiLogModel.logLevel == LogLevel.warning) {
      subTitleColor = Colors.orange;
    } else if (apiLogModel.logLevel == LogLevel.success) {
      subTitleColor = Colors.green;
    }

    String mainTitle = apiLogModel.title ?? '';
    String logHeaderTitle = '';
    late Map<String, dynamic> jsonMap;
    if (apiLogModel.detailLogModel is NetOptions) {
      NetOptions apiInfo = apiLogModel.detailLogModel;

      if (apiLogModel.logInfo != null) {
        Map<String, dynamic> extraLogInfo = apiLogModel.logInfo!; // log 的 额外信息
        ApiProcessType apiProcessType = extraLogInfo["logApiProcessType"];
        // 用于区分api日志是要显示哪个阶段(因为已合并成一个模型)
        ApiMessageModel apiMessageModel =
            ApiInfoGetter.apiMessageModel(apiInfo, apiProcessType);

        logHeaderTitle = apiMessageModel.logHeaderString;
        // logHeaderTitle = apiInfo.getLogHeaderString(apiProcessType);
        // contentText = apiInfo.getDetailLogJsonMap(apiProcessType);

        jsonMap = apiMessageModel.detailLogJsonMap;
      } else {
        jsonMap = {
          "contentText": '无法获取到你想要请求的什么阶段的值',
        };
      }
    } else if (apiLogModel.detailLogModel is Map) {
      jsonMap = apiLogModel.detailLogModel;
    } else {
      jsonMap = {
        "contentText": '此类型的日志详情暂未定义，待补充',
      };
    }
    String contentText = ApiMessageModel.getDetailLogJsonString(jsonMap);

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
                  JsonViewer(jsonMap),
                ],
              )
            : LogBaseTableViewCell(
                maxLines: widget.maxLines ?? 18,
                mainTitle: mainTitle,
                subTitles: [logHeaderTitle, contentText],
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
      child: Container(
        color: Colors.pink,
        width: 260,
        height: 50,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
