/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 22:02:02
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:app_map/app_map.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';

class LocationChooseCellWidget extends StatefulWidget {
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  LocationBean locationBean;
  void Function({LocationBean bLocationBean}) valueChangeBlock;

  LocationChooseCellWidget({
    Key key,
    this.leftRightPadding,
    this.locationBean,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<LocationChooseCellWidget> createState() =>
      LocationChooseCellWidgetState();
}

class LocationChooseCellWidgetState extends State<LocationChooseCellWidget> {
  LocationBean _locationBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    // _locationBean = widget.locationBean;
  }

  // updateLocationBean(LocationBean locationBean) {
  //   setState(() {
  //     _locationBean = locationBean;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _locationBean = widget.locationBean;
    bool hasContent = _locationBean != null;

    return AppImageTitleTextValueCell(
      leftRightPadding: widget.leftRightPadding,
      title: '定位',
      imageProvider: AssetImage(
        'assets/ation.png',
        package: 'app_info_choose_kit',
      ),
      textValue: _locationBean?.address,
      textValuePlaceHodler: '点击选择',
      onTap: () {
        _addLocation(context);
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
        setState(() {});
      },
    );
  }

  void _clearLocation(BuildContext context) {
    _locationBean = null;
    if (widget.valueChangeBlock != null) {
      widget.valueChangeBlock(bLocationBean: _locationBean);
    }
    setState(() {});
  }
}
