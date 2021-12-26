import 'package:flutter/material.dart';
import './environment_add_widget.dart';
import './environment_add_page.dart';

class EnvironmentAddUtil {
  // 取消 + 确定
  static showAddPage(
    BuildContext context,
    // String title,
    // String message,
    // Function() cancelHandle,
    // Function() okHandle,
  ) {
    showAlert(
      context,
      alertViewBulider: (context) {
        return EnvironmentAddPage();
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
        builder: (context) => EnvironmentAddPage(),
      ),
    );
  }
}
