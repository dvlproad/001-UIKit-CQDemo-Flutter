import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/CQModulesHomePage.dart';
// import 'package:tsdemodemo_flutter/modules/home/home_page.dart';
// 举报模块
import 'package:tsdemodemo_flutter/modules/report/report_list_page/report_list_page.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_page.dart';
// 排行榜模块
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_page.dart';

class Routers {
  // 模块的测试首页
  static const moduleHomePage = '/module_home_page';

  // 引导蒙层模块
  static const guideHomePage = '/guide_home_page';
  static const guideOverlayTestPage1 = '/guide_overlay_test_page1';
  static const guideOverlayTestPage2 = '/guide_overlay_test_page2';
  static const guideOverlayTestPage3 = '/guide_overlay_test_page3';
  static const guideOverlayTestPage4 = '/guide_overlay_test_page4';
  static const guideOverlayTestPage5 = '/guide_overlay_test_page5';

  // 举报模块
  // static const reportListPage = ReportListPage.routeName;
  // static const reportUploadPage = ReportDetailUploadPage.routeName;
  static const reportListPage = '/report_list_page';
  static const reportUploadPage = '/report_upload_page';

  // 排行榜模块
  static const rankingListPage = '/ranking_list_page';

  /// generator
  Route<dynamic> generator(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      // 模块的测试首页
      case moduleHomePage:
        {
          return _modulesHomePageRoute(arguments);
        }

      // 举报模块
      case reportListPage:
        {
          return _reportListPageRoute(arguments);
        }
      case reportUploadPage:
        {
          return _reportUploadPageRoute(arguments);
        }

      // 排行榜模块
      case rankingListPage:
        {
          return _rankingListPageRoute(arguments);
        }
    }

    return null;
  }

  /// 模块的测试首页
  MaterialPageRoute _modulesHomePageRoute(arguments) {
    return MaterialPageRoute(builder: (context) {
      return CQModulesHomePage();
    });
  }

  /// 举报-举报类型选择列表页
  MaterialPageRoute _reportListPageRoute(arguments) {
    String _reportTypeId;
    int _reportTypeValue;
    String _reportTypeDescription;

    if (arguments is Map) {
      _reportTypeId = arguments['reportTypeId'];
      _reportTypeValue = arguments['reportTypeValue'];
      _reportTypeDescription = arguments['reportTypeDescription'];
    }
    return MaterialPageRoute(builder: (context) {
      return ReportListPage(
        reportTypeId: _reportTypeId,
        reportTypeValue: _reportTypeValue,
        reportTypeDescription: _reportTypeDescription,
      );
    });
  }

  /// 举报-举报详情上传页
  MaterialPageRoute _reportUploadPageRoute(arguments) {
    String _reportTypeId;
    int _reportTypeValue;
    String _reportTypeDescription;
    String _reportDetailTypeId;
    String _reportDetailTypeDescription;

    if (arguments is Map) {
      _reportTypeId = arguments['reportTypeId'];
      _reportTypeValue = arguments['reportTypeValue'];
      _reportTypeDescription = arguments['reportTypeDescription'];
      _reportDetailTypeId = arguments['reportDetailTypeId'];
      _reportDetailTypeDescription = arguments['reportDetailTypeDescription'];
    }
    return MaterialPageRoute(builder: (context) {
      return ReportDetailUploadPage(
        reportTypeId: _reportTypeId,
        reportTypeValue: _reportTypeValue,
        reportTypeDescription: _reportTypeDescription,
        reportDetailTypeId: _reportDetailTypeId,
        reportDetailTypeDescription: _reportDetailTypeDescription,
      );
    });
  }

  /// 排行榜-影响力排行榜
  MaterialPageRoute _rankingListPageRoute(arguments) {
    String _blockId;
    if (arguments is Map) {
      _blockId = arguments['blockId'];
    }
    return MaterialPageRoute(builder: (context) {
      return RankingListPage(
        blockId: _blockId,
      );
    });
  }
}
