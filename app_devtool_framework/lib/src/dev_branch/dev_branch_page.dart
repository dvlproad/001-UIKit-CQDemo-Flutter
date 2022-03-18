import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './dev_branch_cell.dart';
import './dev_branch_bean.dart';
export './dev_branch_bean.dart';

class DevBranchPage extends StatefulWidget {
  final String brancesRecordTime;
  final List<DevBranchBean> devBranchBeans;

  const DevBranchPage({
    Key key,
    this.brancesRecordTime,
    this.devBranchBeans,
  }) : super(key: key);

  @override
  _DevBranchPageState createState() => _DevBranchPageState();
}

class _DevBranchPageState extends State<DevBranchPage> {
  String _brancesRecordTime;
  List<DevBranchBean> _devBranchBeans;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _brancesRecordTime = widget.brancesRecordTime ?? '';
    _devBranchBeans = [];
    int count = widget.devBranchBeans.length;
    for (var i = count - 1; i >= 0; i--) {
      DevBranchBean devBranchBean = widget.devBranchBeans[i];
      _devBranchBeans.add(devBranchBean);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('当前【开发中】的需求记录'),
      ),
      body: Column(
        children: [
          Text(
            '截止时间:$_brancesRecordTime',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devBranchBeans.length,
              itemBuilder: (context, index) {
                DevBranchBean devBranchBean = _devBranchBeans[index];
                return DevBranchCell(devBranchBean: devBranchBean);
              },
            ),
          ),
        ],
      ),
    );
  }
}
