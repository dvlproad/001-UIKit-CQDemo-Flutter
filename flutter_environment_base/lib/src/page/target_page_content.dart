import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
// import './actionsheet_footer.dart';
// import './environment_add_util.dart';

import '../data_target/packageType_page_data_manager.dart';

import '../target_list.dart';

// import '../environment_change_notifiter.dart';
// export '../environment_change_notifiter.dart';

import '../environment_util.dart';

class TargetPageContent extends StatefulWidget {
  final Function(PackageTargetModel bTargetModel) updateTargetCallback;

  TargetPageContent({
    Key? key,
    required this.updateTargetCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TargetPageContentState();
  }
}

class _TargetPageContentState extends State<TargetPageContent> {
  String networkTitle = "发布平台的大类型";
  late List<PackageTargetModel> _targetModels;
  late PackageTargetModel _selectedTargetModel;

  @override
  void initState() {
    super.initState();

    if (PackageTargetPageDataManager().targetModels.isEmpty) {
      print(
          'error:请在 main_init.dart 中 执行 EnvironmentUtil.completeEnvInternal_whenNull();');
    }
    _targetModels = PackageTargetPageDataManager().targetModels;
    _selectedTargetModel = PackageTargetPageDataManager().selectedTargetModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _bodyWidget,
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text('切换平台'),
    );
  }

  Widget get _bodyWidget {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Expanded(
            child: _pageWidget(),
          ),
        ],
      ),
    );
  }

  Widget _pageWidget() {
    return TargetList(
      networkTitle: networkTitle,
      targetModels: _targetModels,
      selectedTargetModel: _selectedTargetModel,
      clickEnvTargetCellCallback: ({
        int? section,
        int? row,
        required bTargetModel,
        bool? isLongPress,
      }) {
        print('点击了${bTargetModel.name}');

        if (isLongPress == true) {
        } else {
          _tryUpdateToTargetModel(bTargetModel);
        }
      },
    );
  }

  /// 尝试切换环境
  void _tryUpdateToTargetModel(PackageTargetModel bTargetModel) {
    // String oldTarget = _selectedTargetModel.name;
    String newTarget = bTargetModel.name;

    bool shouldExit = true;
    if (EnvironmentUtil.shouldExitWhenChangeTargetEnv != null) {
      shouldExit = EnvironmentUtil.shouldExitWhenChangeTargetEnv!(
          _selectedTargetModel, bTargetModel);
    }
    String message;
    if (shouldExit) {
      message = '温馨提示:如确认切换,则将自动关闭app.(且如果已登录则重启后需要重新登录)';
    } else {
      message = '温馨提示:切换到该环境，您已设置为不退出app也不重新登录';
    }

    AlertUtil.showCancelOKAlert(
      context: context,
      title: '切换到"$newTarget"',
      message: message,
      okHandle: () {
        _confirmUpdateToTargetModel(bTargetModel, shouldExit: shouldExit);
      },
    );
  }

  /// 确认切换环境
  void _confirmUpdateToTargetModel(
    PackageTargetModel bTargetModel, {
    bool shouldExit = true,
  }) {
    _selectedTargetModel = bTargetModel;

    widget.updateTargetCallback(
      bTargetModel,
    );

    setState(() {});
  }
}
