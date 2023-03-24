/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 16:55:02
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './loading_widget.dart'; // 使用 images

class StateLoadingWidget extends StatefulWidget {
  const StateLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  _StateLoadingWidgetState createState() => _StateLoadingWidgetState();
}

class _StateLoadingWidgetState extends State<StateLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return _loadingView;
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Container(
        // color: Color.fromRGBO(22, 170, 175, 0.5),
        width: 200,
        height: 200,
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _loadingWidget,
            // SizedBox(height: 10),
            // Text(
            //   '拼命加载中...',
            //   style: TextStyle(color: Colors.blue, fontSize: 24),
            // ),
          ],
        ),
      ),
    );
  }

  Widget get _loadingWidget {
    return const LoadingWidget();
  }
}
