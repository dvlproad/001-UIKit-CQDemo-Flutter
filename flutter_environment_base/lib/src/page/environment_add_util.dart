/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 15:21:22
 * @Description: 
 */
import 'package:flutter/material.dart';
import './env_add_proxy_page.dart';
import './env_add_network_page.dart';

class EnvironmentAddUtil {
  // 显示添加或修改协议的页面
  static showAddOrUpdateProxyPage(
    BuildContext context, {
    required String proxyName,
    String? proxyIp,
    required Function({required String bProxyName, String? bProxyIp})
        addCompleteBlock,
  }) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return EnvironmentAddProxyPage(
          proxyName: proxyName,
          oldProxyIp: proxyIp,
          callBack: ({String? bProxyIp, required String bProxyName}) {
            addCompleteBlock(bProxyName: bProxyName, bProxyIp: bProxyIp);
          },
        );
      },
    );
  }

  // 显示添加或修改网络环境的页面
  static showAddOrUpdateNetworkPage(
    BuildContext context, {
    required String proxyIp,
    required Function(String bProxyIp) addCompleteBlock,
  }) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return EnvironmentAddNetworkPage(
          oldProxyIp: proxyIp,
          callBack: (bProxyIp) {
            addCompleteBlock(bProxyIp);
          },
        );
      },
    );
  }

  static void showAlert(
    BuildContext context, {
    required Widget Function(BuildContext context) alertViewBulider,
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
