/*
 * @Author: dvlproad
 * @Date: 2022-11-16 10:51:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-02-10 10:15:05
 * @Description: 
 */
import 'package:flutter/material.dart';
import './h5js_model.dart';
import './h5CallBridge_cell.dart';

class H5CallBridgePage extends StatefulWidget {
  final List<H5CallBridgeModel> h5CallBridgeModels;
  final void Function(H5CallBridgeModel h5CallBridgeModel)? onTapCell;

  const H5CallBridgePage({
    Key? key,
    required this.h5CallBridgeModels,
    this.onTapCell,
  }) : super(key: key);

  @override
  _H5CallBridgePageState createState() => _H5CallBridgePageState();
}

class _H5CallBridgePageState extends State<H5CallBridgePage> {
  late List<H5CallBridgeModel> _h5CallBridgeModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _h5CallBridgeModels = widget.h5CallBridgeModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H5调用app方法详情'),
      ),
      body: Column(
        children: [
          /*
          Text(
            '记录时间:$_bridgeRecordTime',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          */
          Expanded(
            child: ListView.builder(
              itemCount: _h5CallBridgeModels.length,
              itemBuilder: (context, index) {
                H5CallBridgeModel h5CallBridgeModel =
                    _h5CallBridgeModels[index];
                return H5CallBridgeCell(
                  h5CallBridgeModel: h5CallBridgeModel,
                  onTap: () {
                    if (widget.onTapCell != null) {
                      widget.onTapCell!(h5CallBridgeModel);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
