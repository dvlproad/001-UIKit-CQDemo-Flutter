/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-02-03 14:47:23
 * @Description: 愿望单标签视图
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './mine_tag_model.dart';

import 'package:wish/route/route_manager.dart';
import 'package:app_network/app_network.dart';

import 'package:flutter_datepicker/flutter_datepicker.dart';
import 'package:app_service_user/app_service_user.dart';

export 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show ButtonImagePosition;

class MineTagView extends StatefulWidget {
  double width;
  double height;

  MineTagModel tagModel;
  void Function() tagClickHandle;

  final bool isDialogView;

  MineTagView({
    Key key,
    this.width,
    @required this.height,
    @required this.tagModel,
    @required this.tagClickHandle,
    this.isDialogView = false,
  }) : super(key: key);

  @override
  State<MineTagView> createState() => _MineTagViewState();
}

class _MineTagViewState extends State<MineTagView> {
  MineTagModel _tagModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tagModel = widget.tagModel;

    bool isSelected = false;

    String title = widget.tagModel.tagName;

    ButtonImagePosition imagePosition = ButtonImagePosition.none;
    if (widget.tagModel.tagIconName != null &&
        widget.tagModel.tagIconName.isNotEmpty) {
      imagePosition = ButtonImagePosition.left;
    }
    return RichThemeStateButton(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.only(right: 5.w_pt_cj),
      padding: EdgeInsets.only(left: 8.w_pt_cj, right: 8.w_pt_cj),
      normalTitle: title,
      selectedTitle: title,
      titleStyle: widget.isDialogView == true
          ? TextStyle(
              fontFamily: 'PingFang SC',
              fontSize: 14.0.f_pt_cj,
              fontWeight: FontWeight.w400,
            )
          : TextStyle(
              fontFamily: 'PingFang SC',
              fontSize: 10.0.f_pt_cj,
              fontWeight: FontWeight.w400,
            ),
      imagePosition: imagePosition,
      imageTitleGap: 4.w_pt_cj,
      imageWidget: Image(
        image: AssetImage(
          _tagModel.tagIconName,
          // package: 'app_info_choose_kit',
        ),
        width: 11.w_pt_cj,
        height: 11.h_pt_cj,
        fit: BoxFit.contain,
      ),
      cornerRadius: widget.height != null ? (widget.height / 2.0) : 6.w_pt_cj,
      richBGColorType: widget.isDialogView == true
          ? RichThemeStateBGType.grey_theme_mine_tag_dialog
          : RichThemeStateBGType.grey_theme_mine_tag_home,
      selected: isSelected,
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        widget.tagClickHandle();
      },
    );
  }
}
