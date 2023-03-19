/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 19:19:54
 * @Description: 位置选择tag视图
 */
import 'package:flutter/material.dart';
import './jurisdiction_bean.dart';

import '../app_info_choose_kit_adapt.dart';
import './base_tag_widget.dart';

class JurisdictionChooseTagWidget extends StatefulWidget {
  JurisdictionBean jurisdictionBean;
  void Function() onTap;

  JurisdictionChooseTagWidget({
    Key key,
    this.jurisdictionBean,
    @required this.onTap,
  }) : super(key: key);

  @override
  State<JurisdictionChooseTagWidget> createState() =>
      JurisdictionChooseTagWidgetState();
}

class JurisdictionChooseTagWidgetState
    extends State<JurisdictionChooseTagWidget> {
  JurisdictionBean _jurisdictionBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _jurisdictionBean = widget.jurisdictionBean;
  }

  @override
  Widget build(BuildContext context) {
    _jurisdictionBean = widget.jurisdictionBean;

    bool hasContent = _jurisdictionBean != null;
    String buttonText = '可见范围';
    String buttonImageName = _jurisdictionBean.text == "公开"
        ? "assets/icon_jurisdiction_open.png"
        : "assets/icon_jurisdiction.png";
    if (hasContent) {
      buttonText = _jurisdictionBean.text;
    }

    return BaseTagWidget(
      buttonText: buttonText,
      buttonImageProvider: AssetImage(
        buttonImageName,
        package: 'app_info_choose_kit',
      ),
      contentWidgetWhenShowDelete: BaseTagText(buttonText),
      onTap: () {
        if (hasContent == false) {
          _addJurisdictionType(context);
        } else {
          _addJurisdictionType(context);
        }
      },
      showDeleteIcon: false,
      onTapDelete: () {
        _clearLocation(context);
      },
    );
  }

  void _addJurisdictionType(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    widget.onTap();
  }

  void _clearLocation(BuildContext context) {
    _jurisdictionBean = null;
    setState(() {});
  }
}
