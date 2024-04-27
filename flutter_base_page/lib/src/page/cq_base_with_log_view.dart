import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_kit/flutter_lifecycle_kit.dart';

import 'cq_base_view.dart';

enum PageShowType {
  unknow, // 未知页面
  tab, // Tab页面
  normal, // 普通页面
}

/// page 在 init 时候即可获得的页面信息
class CJPageInitInfo {
  final String pageDesc;
  final PageShowType pageShowType;
  final String pageClassString;
  final String pageKey;
  final String? pageScene;

  CJPageInitInfo({
    required this.pageDesc,
    this.pageShowType = PageShowType.unknow,
    required this.pageClassString, // 页面的类名
    required this.pageKey, // 页面的key (用于埋点)
    this.pageScene, // 页面场景 (同一个页面不同场景使用 eg:"UserDetailPage_self" "UserDetailPage_other")
  });

  Map<String, dynamic> toJson() {
    return {
      "pageDesc": pageDesc,
      "pageShowType": pageShowType.toString().split(".").last,
      "pageClassString": pageClassString,
      "pageKey": pageKey,
      "pageScene": pageScene,
    };
  }
}

/// page 在 build(context) 时候才可获得的页面信息
class CJPageContextModel {
  final String? pageRoutePath;
  final Map<String, dynamic>? allArgs;
  final Map<String, dynamic>? buriedpointArgs;

  CJPageContextModel({
    this.pageRoutePath,
    this.allArgs, // 页面的所有入参（用于打印页面日志)
    this.buriedpointArgs, // 页面的所有入参中需要用于埋点的部分参数（用于埋点）
  });
}

//class CJBaseWithLogPage extends StatefulWidget {
abstract class CJBaseWithLogPage extends CQBasePage {
  const CJBaseWithLogPage({
    Key? key,
  }) : super(key: key);

// @override
// // CJBaseWithLogPageState createState() => CJBaseWithLogPageState();
// CJBaseWithLogPageState createState() => getState();
// ///子类实现
// CJBaseWithLogPageState getState() {
//   print('请在子类中实现');
// }
}

//class CJBaseWithLogPageState extends State<CJBaseWithLogPage> {
abstract class CJBaseWithLogPageState<V extends CJBaseWithLogPage>
    extends CQBasePageState<V> {
  CJPageInitInfo get pageInitModel => _pageInitModel;
  CJPageContextModel get pageContextModel => _pageContextModel;
  late CJPageInitInfo _pageInitModel;
  late CJPageContextModel _pageContextModel;

  /// 子类实现
  CJPageInitInfo getPageInfoModel(String pageClassString);
  CJPageContextModel getPageContextModel(BuildContext context);
  /*
  CJPageInitInfo getPageInfoModel(String pageClassString) {
    // eg: 同一个页面不同场景使用 "UserDetailPage_self" "UserDetailPage_other"
    String pageKey = pageClassString;
    String pageScene = "self";

    return CJPageInitInfo(
      pageDesc: "",
      pageShowType: PageShowType.normal,
      pageClassString: pageClassString,
      pageKey: pageKey,
      pageScene: pageScene,
    );
  }

  CJPageContextModel getPageContextModel(BuildContext context) {
    // 注意： pageRoutePath 不和 pageClassString 一起写在 initState 是因为 ModalRoute.of(context) 不能写在该方法里。
    String? pageRoutePath;
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      pageRoutePath = route.settings.name;
    }

    // allArgs 、 buriedpointArgs
    Map<String, dynamic>? allArgs = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?; // 有context 所有init时候获取不到
    Map<String, dynamic>? buriedpointArgs = {
      "liveId": "123",
      "fromPageSource": "",
      "chatType": "private",
    };

    return CJPageContextModel(
      pageRoutePath: pageRoutePath,
      allArgs: allArgs,
      buriedpointArgs: buriedpointArgs,
    );
  }
  */

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    String pageClassString = widget.runtimeType.toString();
    _pageInitModel = getPageInfoModel(pageClassString);

    // String pageCode = "${pageClassString}_$hashCode";
  }

  /// 子类重写监控信息
  void updateCurrentAppCatchError(
      String currentPageClassString, String? currentPageRoutePath);
  void updateBeforeAppCatchError(
      String beforePageClassString, String? beforePageRoutePath);

  /// 子类重写埋点
  void execBuriedPoint(String eventName, Map<String, dynamic> eventAttr);

  /// 子类重写日志输出
  void execLog({
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  });

  /*
  flutter_error_catch: ^0.0.2
  flutter_log_with_env: ^0.0.5
  flutter_buried_point: ^0.0.1
  
  import 'package:flutter_log_with_env/flutter_log_with_env.dart';
  import 'package:flutter_error_catch/flutter_error_catch.dart';
  import 'package:flutter_buried_point/flutter_buried_point.dart';
  void updateCurrentAppCatchError(
      String currentPageClassString, String? currentPageRoutePath) {
    AppCatchError.currentPageClassString = currentPageClassString;
    AppCatchError.currentPageRoutePath = currentPageRoutePath;
  }

  void updateBeforeAppCatchError(
      String beforePageClassString, String? beforePageRoutePath) {
    AppCatchError.beforePageClassString = beforePageClassString;
    AppCatchError.beforePageRoutePath = beforePageRoutePath;
  }

  void execBuriedPoint(String eventName, Map<String, dynamic> eventAttr) {
    BuriedPointManager().addEvent(eventName, eventAttr);
  }

  void execLog({
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
  }) {
    AppLogUtil.logMessage(
      needTackTrace: false,
      logType: LogObjectType.route,
      logLevel: LogLevel.success,
      shortMap: shortMap,
      detailMap: detailMap,
    );
  }
  */

  // 用于记录页面停留时长
  DateTime? _pageAppearTime;
  @override
  void viewDidAppear(AppearBecause appearBecause) {
    super.viewDidAppear(appearBecause);
    _pageContextModel = getPageContextModel(context);

    // 若出错,提示【当前的】监控信息
    updateCurrentAppCatchError(
      _pageInitModel.pageClassString,
      _pageContextModel.pageRoutePath,
    );

    // if (appearBecause == AppearBecause.newCreate) {}

    // 埋点上报
    _pageAppearTime = DateTime.now();
    String appearBecauseString = appearBecause.toString().split('.').last;
    Map<String, dynamic> parameters = {
      "page": _pageInitModel.pageClassString,
      "pageKey": _pageInitModel.pageKey,
      "cause": appearBecauseString,
    };
    parameters.addAll(_pageContextModel.buriedpointArgs ?? {});
    execBuriedPoint('viewDidAppear', parameters);

    // 日志输出
    if (_pageInitModel.pageShowType == PageShowType.tab ||
        _pageInitModel.pageShowType == PageShowType.normal) {
      execLog(
        shortMap: getAppearShortMap(),
        detailMap: {
          "pageKey": _pageInitModel.pageKey,
          "arguments": _pageContextModel.allArgs,
        },
      );
    }
  }

  @override
  void viewDidDisappear(DisAppearBecause disAppearBecause) {
    super.viewDidDisappear(disAppearBecause);

    // 若出错,提示【之前的】监控信息
    updateBeforeAppCatchError(
      _pageInitModel.pageClassString,
      _pageContextModel.pageRoutePath,
    );

    // 埋点上报
    String disAppearBecauseString = disAppearBecause.toString().split('.').last;
    Map<String, dynamic> parameters = {
      "page": _pageInitModel.pageClassString,
      "pageKey": _pageInitModel.pageKey,
      "cause": disAppearBecauseString,
      "duration": DateTime.now().millisecondsSinceEpoch -
          _pageAppearTime!.millisecondsSinceEpoch,
    };
    parameters.addAll(_pageContextModel.buriedpointArgs ?? {});
    execBuriedPoint('viewDidDisappear', parameters);

    // 日志输出
    if (_pageInitModel.pageShowType == PageShowType.tab ||
        _pageInitModel.pageShowType == PageShowType.normal) {
      execLog(
        shortMap: getDisappearShortMap(),
        detailMap: {
          "pageKey": _pageInitModel.pageKey,
          "arguments": _pageContextModel.allArgs,
        },
      );
    }
  }

  Map<dynamic, dynamic> getAppearShortMap() {
    String routeNameCN = _pageInitModel.pageDesc;
    if (routeNameCN.isNotEmpty) {
      if (_pageInitModel.pageShowType == PageShowType.tab) {
        return {
          "routeNameCN": "进入Tab页面:$routeNameCN",
        };
      } else {
        return {
          "routeNameCN": "进入页面:$routeNameCN",
        };
      }
    } else {
      return {
        "routePath": "进入页面:${_pageInitModel.pageClassString}",
      };
    }
  }

  Map<dynamic, dynamic> getDisappearShortMap() {
    String routeNameCN = _pageInitModel.pageDesc;
    if (routeNameCN.isNotEmpty) {
      if (_pageInitModel.pageShowType == PageShowType.tab) {
        return {
          "routeNameCN": "离开Tab页面:$routeNameCN",
        };
      } else {
        return {
          "routeNameCN": "离开页面:$routeNameCN",
        };
      }
    } else {
      return {
        "routePath": "离开页面:${_pageInitModel.pageClassString}",
      };
    }
  }
}
