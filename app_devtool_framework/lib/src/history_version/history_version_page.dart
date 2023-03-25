/*
 * @Author: dvlproad
 * @Date: 2022-11-16 10:51:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-16 15:50:32
 * @Description: 
 */
import 'package:flutter/material.dart';
import './history_version_cell.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show HistoryVersionBean;

class HistoryVersionPage extends StatefulWidget {
  final String? historyRecordTime;
  final List<HistoryVersionBean>? historyVersionBeans;

  const HistoryVersionPage({
    Key? key,
    this.historyRecordTime,
    this.historyVersionBeans,
  }) : super(key: key);

  @override
  _HistoryVersionPageState createState() => _HistoryVersionPageState();
}

class _HistoryVersionPageState extends State<HistoryVersionPage> {
  late String _historyRecordTime;
  late List<HistoryVersionBean> _historyVersionBeans;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _historyRecordTime = widget.historyRecordTime ?? '';
    _historyVersionBeans = widget.historyVersionBeans ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史版本记录'),
      ),
      body: Column(
        children: [
          Text(
            '记录时间:$_historyRecordTime',
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.red),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _historyVersionBeans.length,
              itemBuilder: (context, index) {
                HistoryVersionBean historyVersionBean =
                    _historyVersionBeans[index];
                return HistoryVerisonCell(
                  historyVersionBean: historyVersionBean,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
