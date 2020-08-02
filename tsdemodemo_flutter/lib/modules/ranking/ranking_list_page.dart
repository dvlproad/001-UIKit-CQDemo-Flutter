/*
 * ranking_list_page.dart
 *
 * @Description: 影响力排行榜
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/27 16:35
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_me.dart';
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_model.dart';
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_model_mock.dart';

import 'rankling_bean.dart';

class RankingListPage extends StatefulWidget {
  final String blockId; // 区块id

  RankingListPage({Key key, this.blockId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RankingListPageState();
  }
}

class _RankingListPageState extends State<RankingListPage> {
  String _blockId;

  RankingListModel _rankingListModel = RankingListModel();
  RankingFullBean _rankingBean;
  bool _isLoadingSuccess = false;

  @override
  void dispose() {
    _rankingListModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _blockId = widget.blockId ?? '';

    // _rankingListModel.requestRankingList(_blockId).then((value) {
    mockRequest_rankingListData(_blockId).then((value) {
      print(value);
      _rankingBean = RankingFullBean(value);

      _isLoadingSuccess = true;

      setState(() {});
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: _lastPageWidget(),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('影响力排行榜'),
    );
  }

  Widget _lastPageWidget() {
    if (_isLoadingSuccess) {
      return _pageWidget();
    } else {
      return Container();
    }
  }

  Widget _pageWidget() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: RankingList(
              rankingDataModels:
                  _rankingBean.rows == null ? [] : _rankingBean.rows,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: 1,
            color: Color(0x80343434),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              '更新于' + _rankingBean.updateDate.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF7E7E7E)),
            ),
          ),
          RankingListBottom(
            showIndex: false,
            dataBean: _rankingBean.me,
          ),
        ],
      ),
    );
  }
}
