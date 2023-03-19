/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 19:57:15
 * @Description: 位置选择tag视图
 */
import 'package:flutter/material.dart';
import 'package:app_map/app_map.dart';

import '../app_info_choose_kit_adapt.dart';
import './base_tag_widget.dart';

class LocationChooseTagWidget extends StatefulWidget {
  final double width;
  final BoxConstraints constraints;
  final bool shouldExpandedButtonText;

  LocationBean locationBean;
  void Function({LocationBean bLocationBean}) valueChangeBlock;

  LocationChooseTagWidget({
    Key key,
    this.width,
    this.constraints,
    this.shouldExpandedButtonText,
    this.locationBean,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<LocationChooseTagWidget> createState() =>
      LocationChooseTagWidgetState();
}

class LocationChooseTagWidgetState extends State<LocationChooseTagWidget> {
  LocationBean _locationBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _locationBean = widget.locationBean;
  }

  @override
  Widget build(BuildContext context) {
    //   return LayoutBuilder(
    //       builder: (BuildContext context, BoxConstraints constraints) {
    //     double currentMaxWidth = constraints.maxWidth;
    //     debugPrint("currentMaxWidth2 = $currentMaxWidth");
    //     return buildContent(context);
    //   });
    // }

    // Widget buildContent(BuildContext context) {
    bool hasContent = _locationBean != null;
    String buttonText = '添加位置';
    String buttonImageName = "assets/icon_location_disable.png";
    if (hasContent) {
      buttonText = _locationBean.address;
      buttonImageName = "assets/icon_location.png";
    }

    return BaseTagWidget(
      width: widget.width,
      shouldExpandedButtonText: widget.shouldExpandedButtonText,
      constraints: widget.constraints,
      buttonText: buttonText,
      buttonImageProvider: AssetImage(
        buttonImageName,
        package: 'app_info_choose_kit',
      ),
      contentWidgetWhenShowDelete: BaseTagText(buttonText),
      onTap: () {
        if (hasContent == false) {
          _addLocation(context);
        } else {
          _addLocation(context);
        }
      },
      showDeleteIcon: !hasContent ? false : true,
      onTapDelete: () {
        _clearLocation(context);
      },
    );
  }

  void _addLocation(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    LocationUtil.goChooseLocationPage(
      context,
      chooseCompleteBlock: ({bLocationBean}) {
        _locationBean = bLocationBean;

        if (widget.valueChangeBlock != null) {
          widget.valueChangeBlock(bLocationBean: _locationBean);
        }
      },
    );
  }

  void _clearLocation(BuildContext context) {
    _locationBean = null;
    if (widget.valueChangeBlock != null) {
      widget.valueChangeBlock(bLocationBean: _locationBean);
    }
  }
}
