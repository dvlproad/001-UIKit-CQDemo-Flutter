
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/emptyview.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/searchbar.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _pageWidget(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('搜索模块'),
    );
  }

  Widget _pageWidget() {
    return Container(
      color: Colors.black,
      height: 400,
      child: Column(
        children: <Widget>[
          SearchBar(
              searchText: '1',
              searchPlaceholder: '请输入',
              onSubmitted: (String text) {
                print('最后搜索的内容为:' + text);
              }
          ),
          _searchResultWidget(),
        ],
      ),
    );
  }

  Widget _searchResultWidget() {
    if (true) {
      return EmptyView(text: '没有匹配的搜索结果');
    } else {
      return EmptyView(text: '没有匹配的搜索结果');
    }
  }
}

