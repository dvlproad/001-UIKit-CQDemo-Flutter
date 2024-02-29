/*
 * @Author: dvlproad
 * @Date: 2024-01-26 15:29:53
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-28 15:44:04
 * @Description: 
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import '../flutter_share_kit_adapt.dart';
import './share_action_model.dart';

class ShareDialogWidget extends StatefulWidget {
  final List<BaseActionModel> shareActionModels;
  final List<BaseActionModel>? operateActionModels;

  const ShareDialogWidget({
    Key? key,
    required this.shareActionModels,
    this.operateActionModels,
  }) : super(key: key);

  @override
  _ShareDialogWidgetState createState() => _ShareDialogWidgetState();
}

class _ShareDialogWidgetState extends State<ShareDialogWidget> {
  double _botbarH = 0;

  @override
  void initState() {
    super.initState();
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

    _botbarH = mediaQuery.padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.w_pt_cj),
              topLeft: Radius.circular(10.w_pt_cj),
            ),
          ),
          padding: EdgeInsets.only(top: 15.h_pt_cj),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _renderTitle(),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: 15.w_pt_cj,
                    right: 15.w_pt_cj,
                    top: 0,
                    bottom: 0,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _renderShareList(),
                  ),
                ),
              ),
              if (widget.operateActionModels != null &&
                  widget.operateActionModels!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.w_pt_cj),
                  child: Divider(
                    indent: 15.w_pt_cj,
                    endIndent: 15.w_pt_cj,
                    height: 1,
                    color: const Color(0xffC2C2C2),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: 15.w_pt_cj,
                    right: 15.w_pt_cj,
                    top: 0,
                    bottom: 0,
                  ),
                  child: Row(
                    children: _renderOperateList(),
                  ),
                ),
              ),
              SizedBox(height: _botbarH + 10.h_pt_cj),
            ],
          ),
        ),
      ],
    );
  }

  _renderTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w_pt_cj)
          .add(EdgeInsets.only(bottom: 30.h_pt_cj)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '分享至',
            style: BoldTextStyle(
              color: const Color(0xff404040),
              fontSize: 16.w_pt_cj,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.only(left: 10.w_pt_cj),
              child: Image.asset(
                "assets/share_close.png",
                package: "flutter_share_kit",
                width: 20.w_pt_cj,
                height: 20.h_pt_cj,
                color: const Color(0xff404040),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderShareList() {
    List<Widget> list = [];
    for (BaseActionModel shareActionModel in widget.shareActionModels) {
      Widget shareCell = _renderItem(shareActionModel);
      list.add(shareCell);
    }
    return list;
  }

  List<Widget> _renderOperateList() {
    if (widget.operateActionModels == null ||
        widget.operateActionModels!.isEmpty) {
      return [];
    }

    List<Widget> list = [];

    for (BaseActionModel operateActionModel in widget.operateActionModels!) {
      Widget operateCell = _renderItem(operateActionModel);
      list.add(operateCell);
    }

    return list;
  }

  _renderItem<T>(BaseActionModel shareActionModel) {
    return GestureDetector(
      onTap: () async {
        shareActionModel.handle();
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.w_pt_cj),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              shareActionModel.imageName,
              package: shareActionModel.imagePackage,
              width: 50.w_pt_cj,
              height: 50.w_pt_cj,
              fit: BoxFit.contain,
            ),
            Container(height: 8.h_pt_cj),
            SizedBox(
              width: 60.w_pt_cj,
              child: Text(
                shareActionModel.title,
                textAlign: TextAlign.center,
                style: RegularTextStyle(
                  fontSize: 14,
                  color: shareActionModel.titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
