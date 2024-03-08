/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-07 15:03:45
 * @Description: 
 */

import 'package:flutter/material.dart';

import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';

class TSSharePopupContainer extends StatefulWidget {
  final Widget Function() contentWidgetGetBlock;

  const TSSharePopupContainer({
    Key? key,
    required this.contentWidgetGetBlock,
  }) : super(key: key);

  @override
  State<TSSharePopupContainer> createState() => _TSSharePopupContainerState();
}

class _TSSharePopupContainerState extends State<TSSharePopupContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 40.h_pt_cj, bottom: 40.h_pt_cj),
              child: widget.contentWidgetGetBlock(),
            ),
          ),
        ],
      ),
    );
  }
}
