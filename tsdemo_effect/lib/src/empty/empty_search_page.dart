import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSEmptySearchPage extends StatefulWidget {
  TSEmptySearchPage({Key key}) : super(key: key);

  @override
  _TSEmptySearchPagetate createState() => _TSEmptySearchPagetate();
}

class _TSEmptySearchPagetate extends State<TSEmptySearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh(全局默认文本)"),
      ),
      body: Center(
        child: CQFullEmptyView(text: '没有匹配的搜索结果'),
      ),
    );
  }
}
