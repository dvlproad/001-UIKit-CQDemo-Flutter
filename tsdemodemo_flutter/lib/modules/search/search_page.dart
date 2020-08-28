import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSTableViewCell.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSTableViewHeader.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/section_table_view_method2.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/emptyview.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/searchbar.dart';
import 'package:tsdemodemo_flutter/commonutil/data_search_util.dart';
import 'package:tsdemodemo_flutter/modules/search/seach_datas_util.dart';
import 'package:tsdemodemo_flutter/modules/search/search_change_notifiter.dart';
import 'package:tsdemodemo_flutter/modules/search/search_data_bean.dart';
//import 'package:tsdemodemo_flutter/modules/search/serchbar_delegate.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  SearchChangeNotifier _searchChangeNotifier = SearchChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: ChangeNotifierProvider<SearchChangeNotifier>.value(
        value: _searchChangeNotifier,
        child: _pageWidget(),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('搜索模块'),
    );
  }

  Widget _pageWidget() {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
            child: SearchBar(
              searchText: '',
              searchPlaceholder: '请输入',
              onSearchTextChanged: (String text) {
                print('搜索内容更新为:' + text);
                _searchChangeNotifier.searchTextChange(text);
              },
              onSubmitted: (String text) {
                print('搜索内容最后为:' + text);
                // showSearch(context: this.context, delegate: SearchBarDelegate());
              },
            ),
          ),
          Consumer<SearchChangeNotifier>(
            builder: (context, _searchChangeNotifier, child) {
              String searchText = _searchChangeNotifier.searchText ?? '';
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  onHorizontalDragEnd: (_) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  onVerticalDragEnd: (_) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: _searchResultWidget(searchText),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchResultWidget(String searchText) {
    bool isSearching = true;

    List<CJSectionDataModel> originSectionDataModels =
        TSSearchDataUtil.getSearchSectionDataModels();

    List<CJSectionDataModel> searchInSectionDataModels =
        originSectionDataModels;
    String dataModelSearchSelector = 'name';
    // List<CJSectionDataModel> resultSectionDataModels =
    List resultSectionDataModels =
        CJDataSearchUtil.searchTextInSectionDataModels(
      searchText,
      searchInSectionDataModels,
      dataModelSearchSelector,
      searchType: CJSearchType.CJSearchTypeFull,
      supportPinyin: true,
      pinyinFromStringBlock: (String string) {
        return PinyinHelper.getPinyin(string,
            separator: "", format: PinyinFormat.WITHOUT_TONE);
      },
    );

    if (isSearching && resultSectionDataModels.length == 0) {
      return FullEmptyView(text: '没有匹配的搜索结果');
    }

    // List<CJSectionDataModel> lastSectionModels =
    List lastSectionModels =
        isSearching ? resultSectionDataModels : originSectionDataModels;

    return _searchResultListWidget(lastSectionModels);
  }

  Widget _searchResultListWidget(List lastSectionModels) {
    int sectionCount = lastSectionModels.length;
    int numOfRowInSection(section) {
      CJSectionDataModel sectionModel = lastSectionModels[section];
      List<dynamic> dataModels = sectionModel.values;
      return dataModels.length;
    }

    return CreateSectionTableView2(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return numOfRowInSection(section);
      },
      headerInSection: (section) {
        CJSectionDataModel sectionModel = lastSectionModels[section];
        return CJTSTableViewHeader(title: sectionModel.theme);
      },
      cellAtIndexPath: (section, row) {
        CJSectionDataModel sectionModel = lastSectionModels[section];
        List<dynamic> dataModels = sectionModel.values;
        TSSearchDataModel dataModel = dataModels[row] as TSSearchDataModel;
        return CJTSTableViewCell(
          text: dataModel.name,
          section: section,
          row: row,
          clickCellCallback: (section, row) {
            print('点击界面');
          },
        );
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
