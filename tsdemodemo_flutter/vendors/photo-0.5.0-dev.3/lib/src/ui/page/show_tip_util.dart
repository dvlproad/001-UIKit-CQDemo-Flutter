import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo/src/entity/options.dart';
import 'package:oktoast/oktoast.dart';

class ShowTipUtil {
  static void showTip({
    @required BuildContext context,
    @required I18nProvider i18nProvider,
    @required Options options,
  }) {
    // if (isPushed) {
    //   return;
    // }
    String message = i18nProvider.getMaxTipText(options);
    showToast(message);

    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       message,
    //       style: TextStyle(
    //         color: options.textColor,
    //         fontSize: 14.0,
    //       ),
    //     ),
    //     duration: Duration(milliseconds: 1500),
    //     backgroundColor: options.themeColor.withOpacity(0.7),
    //   ),
    // );
  }
}
