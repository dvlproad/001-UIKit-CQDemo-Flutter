import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/home/home_page.dart';
import 'package:tsdemodemo_flutter/modules/report/report_list_page/report_list_page.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_page.dart';

class Routers {
  // static const reportListPage = ReportListPage.routeName;
  // static const reportUploadPage = ReportDetailUploadPage.routeName;
  static const reportListPage = '/report_list_page';
  static const reportUploadPage = '/report_upload_page';

  /// generator
  Route<dynamic> generator(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      // 举报模块
      case reportListPage:
        {
          return _reportListPageRoute(arguments);
        }
      case reportUploadPage:
        {
          return _reportListPageRoute(arguments);
        }
    }

    return null;
  }

  /// 举报类型选择列表页
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

  /// 举报详情上传页
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
}
