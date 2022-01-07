import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

class DevUtil {
  // 显示开发工具的悬浮按钮
  static void showDevFloatingWidget(
    BuildContext context, {
    double left = 80,
    double top = 180,
    bool showTestApiWidget,
  }) {
    Widget cell({String title, void Function() onPressed}) {
      return Container(
        child: TextButton(
          child: Text(title, style: TextStyle(color: Colors.white)),
          onPressed: onPressed,
        ),
      );
    }

    ApplicationDraggableManager.addOverlayEntry(
      left: left,
      top: top,
      child: Container(
        color: Color(0xFFFF00FF),
        child: Column(
          children: [
            cell(
              title: '切换环境',
              onPressed: () {
                goChangeEnvironment(context,
                    showTestApiWidget: showTestApiWidget);
              },
            ),
            cell(
              title: 'mock api',
              onPressed: () {
                goChangeApiMock(context, showTestApiWidget: showTestApiWidget);
              },
            ),
            cell(
              title: '返回',
              onPressed: () {
                bool canPop = Navigator.canPop(context);
                if (canPop) {
                  Navigator.pop(context);
                }
              },
            ),
            cell(
              title: '关闭悬浮',
              onPressed: () {
                ApplicationDraggableManager.removeOverlayEntry();
              },
            ),
          ],
        ),
      ),
      ifExistUseOld: true,
    );
  }

  static goChangeEnvironment(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    EnvironmentUtil.goChangeEnvironment(
      context,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
              // HttpManager.getInstance().post(
              //   'user/account/getConsigneeAddresses',
              //   params: {"accountId": UserInfoManager.instance.userModel.id},
              // );
            }
          : null,
      updateNetworkCallback: (apiHost, webHost, gameHost) {
        HttpManager.changeHost(
          apiHost: apiHost,
          webHost: webHost,
          gameHost: gameHost,
        );
      },
      updateProxyCallback: (proxyIp) {
        HttpManager.changeProxy(proxyIp);
      },
    );
  }

  static goChangeApiMock(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    EnvironmentUtil.goChangeApiMock(
      context,
      mockApiHost: simulateApiHost,
      onPressTestApiCallback: showTestApiWidget
          ? () {
              // 我的收货地址
              // Api.getAddressList(
              //     {"accountId": UserInfoManager.instance.userModel.id});
            }
          : null,
    );
  }
}
