import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';

class TSSectionTableViewPage extends CJTSBasePage {
  final String title;

  TSSectionTableViewPage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState
    extends CJTSBasePageState<TSSectionTableViewPage> {
  var sectionModels = [];

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "组件",
        'values': [
          {'title': "Button(按钮)", 'nextPageName': "TSButtonHomePage"},
          {'title': "Image(图片)", 'nextPageName': "TSImageHomePage"},
          // { 'title': "ToolBar(工具器)", 'nextPageName': "ToolBarHomePage" },
        ]
      },
      {
        'theme': "弹窗/蒙层",
        'values': [
          {'title': "Toast", 'nextPageName': "TSToastPage"},
          {'title': "Alert", 'nextPageName': "TSAlertPage"},
          {'title': "ActionSheet", 'nextPageName': "TSActionSheetPage"},
        ]
      }
    ];
    var sectionModels2 = [
      {
        'theme': "组件",
        'values': [
          {'title': "Button(按钮)", 'nextPageName': "TSButtonHomePage"},
          {'title': "Image(图片)", 'nextPageName': "TSImageHomePage"},
          // { 'title': "ToolBar(工具器)", 'nextPageName': "ToolBarHomePage" },
        ]
      },
      {
        'theme': "弹窗/蒙层",
        'values': [
          {'title': "Toast", 'nextPageName': "TSToastPage"},
          {'title': "Alert", 'nextPageName': "TSAlertPage"},
          {'title': "ActionSheet", 'nextPageName': "TSActionSheetPage"},
        ]
      },
      {
        'theme': "选择器",
        'values': [
          // { 'title': "Picker(选择器)", 'nextPageName': "TSPickerAllHomePage" },
          {'title': "DatePicker(日期选择)", 'nextPageName': "TSDatePickerHomePage"},
          {'title': "DateText(日期选择)", 'nextPageName': "TSDateTextHomePage"},
          {'title': "AreaPicker(地区选择)", 'nextPageName': "TSPickerAreaHomePage"},
          {
            'title': "ItemPicker(事项选择(单选、多选))",
            'nextPageName': "TSPickerItemHomePage"
          },
        ]
      },
      {
        'theme': "弹窗管理",
        'values': [
          {'title': "PopupManager(弹窗管理)", 'nextPageName': "TSPopupManagerPage"},
        ]
      },
      {
        'theme': "列表",
        'values': [
          // { 'title': "Table(列表视图)", 'nextPageName': "ListHomePage" },
          // { 'title': "Collection(集合视图)", 'nextPageName': "CollectionHomePage" },
          {
            'title': "TSImagesLookListPage(图片展示列表)",
            'nextPageName': "TSImagesLookListPage"
          },
          {
            'title': "TSImagesChooseListPage(图片选择列表)",
            'nextPageName': "TSImagesChooseListPage"
          },
          {
            'title': "TSModulesEntryListPage(模块功能入口列表)",
            'nextPageName': "TSModulesEntryListPage"
          },
          {
            'title': "TSCycleCollectionPage(轮播图)",
            'nextPageName': "TSCycleCollectionPage"
          },
        ]
      },
      {
        'theme': "图片相关",
        'values': [
          {
            'title': "TSPhotoBrowserPage(图片浏览)",
            'nextPageName': "TSPhotoBrowserPage"
          },
        ]
      },
      {
        'theme': "其他",
        'values': [
          {
            'title': "TSSegmentedPage(界面分段选择器)",
            'nextPageName': "TSSegmentedPage"
          },
          {'title': "TSMenuPage(下拉菜单选择页)", 'nextPageName': "TSMenuPage"},
          {
            'title': "TSVerticalMenuCollectionPage(竖直菜单)",
            'nextPageName': "TSVerticalMenuCollectionPage"
          },
          {
            'title': "TSExcelHomePage(Excel)",
            'nextPageName': "TSExcelHomePage"
          },
        ]
      },
      {
        'theme': "效果",
        'values': [
          {'title': "Refresh(下拉刷新)", 'nextPageName': "TSRefreshHomePage"},
        ]
      },
      {
        'theme': "通过继承基类实现页面",
        'values': [
          {
            'title': "TSDescriptionListPage(介绍列表)",
            'nextPageName': "TSDescriptionListPage"
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
