import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/theme/overlay_theme_manager.dart';
// import 'package:flutter_button_base/flutter_button_base.dart';
// import 'package:flutter_button_base/flutter_button_base_adapt.dart';

import '../../flutter_overlay_kit_adapt.dart';
import '../../theme/overlay_alert_theme_model.dart';

/*
 * 有间隔的'取消'+'确定' Buttons
 */
class AlertdCancelOKSpacedButtons extends StatelessWidget {
  final String cancelTitle;
  final void Function() cancelHandle;

  final String okTitle;
  final void Function() okHandle;

  AlertdCancelOKSpacedButtons({
    Key? key,
    this.cancelTitle = '取消',
    required this.cancelHandle,
    this.okTitle = '确认',
    required this.okHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: _row(),
          ),
        ],
      ),
    );
  }

  Widget _row() {
    CJOverlayAlertThemeModel alertThemeModel =
        CJBaseOverlayThemeManager().alertThemeModel;
    TextStyle titleStyle = TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.bold,
      fontSize: 14.f_pt_cj,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CJButton(
          width: 116.w_pt_cj,
          height: alertThemeModel.actionButtonHeight,
          childMainAxisAlignment: MainAxisAlignment.center,
          title: this.cancelTitle,
          titleStyle: titleStyle,
          cornerRadius: alertThemeModel.actionButtonCornerRadius,
          normalConfig: alertThemeModel.cancelButtonConfig,
          onPressed: this.cancelHandle,
        ),
        Container(width: 10.w_pt_cj),
        CJButton(
          width: 116.w_pt_cj,
          height: alertThemeModel.actionButtonHeight,
          childMainAxisAlignment: MainAxisAlignment.center,
          title: this.okTitle,
          titleStyle: titleStyle,
          cornerRadius: alertThemeModel.actionButtonCornerRadius,
          normalConfig: alertThemeModel.okButtonConfig,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.okHandle();
            });
          },
        ),
      ],
    );
  }
}

/*
 * '我知道了' Button
 */
class AlertIKnowSpacedButton extends StatelessWidget {
  final String iKnowTitle;
  final Function iKnowHandle;

  AlertIKnowSpacedButton({
    Key? key,
    this.iKnowTitle = '我知道了',
    required this.iKnowHandle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Divider(color: Colors.grey, height: 1),
          Container(height: 40, child: _row())
        ],
      ),
    );
  }

  Widget _row() {
    CJOverlayAlertThemeModel alertThemeModel =
        CJBaseOverlayThemeManager().alertThemeModel;
    TextStyle titleStyle = TextStyle(
      fontFamily: 'PingFang SC',
      fontWeight: FontWeight.bold,
      fontSize: 14.f_pt_cj,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CJButton(
          width: 240.w_pt_cj,
          height: alertThemeModel.actionButtonHeight,
          childMainAxisAlignment: MainAxisAlignment.center,
          title: this.iKnowTitle,
          titleStyle: titleStyle,
          cornerRadius: alertThemeModel.actionButtonCornerRadius,
          normalConfig: alertThemeModel.iKnowButtonConfig,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 100), () {
              this.iKnowHandle();
            });
          },
        ),
        // FlatButton(
        //   // color: color,
        //   // shape: StadiumBorder(),
        //   onPressed: () {
        //     Future.delayed(Duration(milliseconds: 100), () {
        //       if (this.iKnowTitle != null) {
        //         this.iKnowHandle();
        //       }
        //     });
        //   },
        //   child: Text(
        //     this.iKnowTitle,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 16.0, color: Colors.white),
        //   ),
        // )
      ],
    );
  }
}
