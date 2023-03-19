/*
 * @Author: dvlproad
 * @Date: 2022-11-16 10:51:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-16 15:56:13
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show DevBranchBean;
import './dev_branch_cell.dart';

class DevBranchPage extends StatefulWidget {
  final String brancesRecordTime;
  final List<DevBranchBean> devBranchBeans;

  const DevBranchPage({
    Key? key,
    required this.brancesRecordTime,
    required this.devBranchBeans,
  }) : super(key: key);

  @override
  _DevBranchPageState createState() => _DevBranchPageState();
}

class _DevBranchPageState extends State<DevBranchPage> {
  late String _brancesRecordTime;
  late List<DevBranchBean> _devBranchBeans;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _brancesRecordTime = widget.brancesRecordTime;
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
        title: Text('需求详情($_brancesRecordTime)'),
      ),
      body: Column(
        children: [
          /*
          Text(
            '记录时间:$_brancesRecordTime',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          */
          Expanded(
            child: ListView.builder(
              itemCount: _devBranchBeans.length,
              itemBuilder: (context, index) {
                DevBranchBean devBranchBean = _devBranchBeans[index];
                return DevBranchCell(
                  devBranchBean: devBranchBean,
                  branchIndex: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
