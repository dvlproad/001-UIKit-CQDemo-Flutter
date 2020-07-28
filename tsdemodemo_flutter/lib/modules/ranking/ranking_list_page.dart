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
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_bean.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_bottom.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_cell.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_top.dart';
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_model.dart';
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_model_mock.dart';

class RankingListPage extends StatefulWidget {
  String blockId; // 区块id

  RankingListPage({Key key, this.blockId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RankingListPageState();
  }
}

class _RankingListPageState extends State<RankingListPage> {
  String _blockId;

  RankingListModel _rankingListModel = RankingListModel();
  //List<Map<String, dynamic>> _rankingDataModels = [];
  List<RankingBean> _rankingDataModels = [];
  Map<String, dynamic> _mineRankingDataMap = {};

  @override
  void dispose() {
    _rankingListModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _blockId = widget.blockId ?? '';

//    _rankingListModel.requestRankingList().then((value) {
    mockRequest_rankingListData().then((value) {
      print(value);
      RankingListBean rankingListBean = RankingListBean.fromJson(value['rows']);
      _rankingDataModels = rankingListBean.beans;
      _mineRankingDataMap = value['me'];

      setState(() {

      });
    }).catchError((onError) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('影响力排行榜'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          color: Colors.black,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              RankingListTop(),
              Expanded(
                child: _reportListWidget(),
              ),
              _mineWidget(),
            ],
          ),
        ),
      ),
    );
  }



  Widget _reportListWidget() {
    return RankingList(
      rankingDataModels: _rankingDataModels,
    );
  }

  Widget _mineWidget() {
    return RankingListBottom(
      showIndex: false,
      dataMap: _mineRankingDataMap,
    );
  }
}
