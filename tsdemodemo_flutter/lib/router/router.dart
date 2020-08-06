import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/CQModulesHomePage.dart';
// import 'package:tsdemodemo_flutter/modules/home/home_page.dart';
// 举报模块
import 'package:tsdemodemo_flutter/modules/report/report_list_page/report_list_page.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_page.dart';
// 排行榜模块
import 'package:tsdemodemo_flutter/modules/ranking/ranking_list_page.dart';

// 设计模式模块
import 'package:tsdemodemo_flutter/modules/architecture/0setState/theme_result_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_result_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc/theme_result_page3.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_result_page4.dart';
import 'package:tsdemodemo_flutter/modules/architecture/redux/theme_result_page5.dart';

class Routers {
  // 模块的测试首页
  static const moduleHomePage = '/module_home_page';

  // 工具的测试首页
  static const utilHomePage = '/util_home_page';

  // 设计模式的测试首页
  static const architectureHomePage = '/architecture_home_page';
  static const arc0SetStatePage = '/architecture_0setState_page';
  static const arcProviderUsePage0 = '/architecture_ProviderUse_page0';
  static const arcProviderUsePage1 = '/architecture_ProviderUse_page1';
  static const arcProviderUsePage2 = '/architecture_ProviderUse_page2';
  static const arcProviderUsePage3 = '/architecture_ProviderUse_page3';

  static const arc1ProviderPage = '/architecture_1Provider_page';
  static const arc1ProviderSharePage = '/architecture_1ProviderShare_page';
  static const arc2BlockPage = '/architecture_2Block_page';
  static const arc2BlockProviderPage = '/architecture_2BlockProvider_page';
  static const arc3ReduxPage = '/architecture_3Redux_page';

  // 组件模块
  static const sectionTableViewMethod1Page = '/section_table_view_method1_page';
  static const sectionTableViewMethod2Page = '/section_table_view_method2_page';

  // 引导蒙层模块
  static const guideHomePage = '/guide_home_page';
  static const guideOverlayTestPage1 = '/guide_overlay_test_page1';
  static const guideOverlayTestPage2 = '/guide_overlay_test_page2';
  static const guideOverlayTestPage3 = '/guide_overlay_test_page3';

  // 搜索模块
  static const searchPage = '/search_page';

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
