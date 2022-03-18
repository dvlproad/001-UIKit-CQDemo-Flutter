import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './history_version_cell.dart';
import './history_version_bean.dart';
export './history_version_bean.dart';

class HistoryVersionPage extends StatefulWidget {
  final String historyRecordTime;
  final List<HistoryVersionBean> historyVersionBeans;

  const HistoryVersionPage({
    Key key,
    this.historyRecordTime,
    this.historyVersionBeans,
  }) : super(key: key);

  @override
  _HistoryVersionPageState createState() => _HistoryVersionPageState();
}

class _HistoryVersionPageState extends State<HistoryVersionPage> {
  String _historyRecordTime;
  List<HistoryVersionBean> _historyVersionBeans;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _historyRecordTime = widget.historyRecordTime ?? '';
    _historyVersionBeans = widget.historyVersionBeans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('当前【已上线】的版本记录'),
      ),
      body: Column(
        children: [
          Text(
            '截止时间:$_historyRecordTime',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _historyVersionBeans.length,
              itemBuilder: (context, index) {
                HistoryVersionBean historyVersionBean =
                    _historyVersionBeans[index];
                return HistoryVerisonCell(
                    historyVersionBean: historyVersionBean);
              },
            ),
          ),
        ],
      ),
    );
  }
}
