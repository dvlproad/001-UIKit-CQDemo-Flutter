import 'package:flutter/material.dart';
import './env_add_proxy_page.dart';
import './env_add_network_page.dart';

class EnvironmentAddUtil {
  // 显示添加或修改协议的页面
  static showAddOrUpdateProxyPage(
    @required BuildContext context, {
    String proxyName,
    String proxyIp,
    @required Function({String bProxyName, String bProxyIp}) addCompleteBlock,
  }) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return EnvironmentAddProxyPage(
          proxyName: proxyName,
          oldProxyIp: proxyIp,
          callBack: ({bProxyIp, bProxyName}) {
            if (addCompleteBlock != null) {
              addCompleteBlock(bProxyName: bProxyName, bProxyIp: bProxyIp);
            }
          },
        );
      },
    );
  }

  // 显示添加或修改网络环境的页面
  static showAddOrUpdateNetworkPage(
    @required BuildContext context, {
    String proxyIp,
    @required Function(String bProxyIp) addCompleteBlock,
  }) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return EnvironmentAddNetworkPage(
          oldProxyIp: proxyIp,
          callBack: (bProxyIp) {
            if (addCompleteBlock != null) {
              addCompleteBlock(bProxyIp);
            }
          },
        );
      },
    );
  }

  static void showAlert(
    @required BuildContext context, {
    @required Widget Function(BuildContext context) alertViewBulider,
  }) {
    // showDialog(
    //   context: context,
    //   builder: (_) => Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: <Widget>[alertViewBulider(context)],
    //   ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return alertViewBulider(context);
        },
      ),
    );
  }
}
