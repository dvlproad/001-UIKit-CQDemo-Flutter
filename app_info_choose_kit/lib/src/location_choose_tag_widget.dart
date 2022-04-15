import 'package:flutter/material.dart';
import 'package:app_map/app_map.dart';

import '../app_info_choose_kit_adapt.dart';
import './base_tag_widget.dart';

class LocationChooseTagWidget extends StatefulWidget {
  LocationBean locationBean;
  LocationChooseTagWidget({
    Key key,
    this.locationBean,
  }) : super(key: key);

  @override
  State<LocationChooseTagWidget> createState() =>
      _LocationChooseTagWidgetState();
}

class _LocationChooseTagWidgetState extends State<LocationChooseTagWidget> {
  LocationBean _locationBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _locationBean = widget.locationBean;
  }

  @override
  Widget build(BuildContext context) {
    bool hasContent = _locationBean != null;
    String buttonText = '点击选择定位';
    String buttonImageName = "assets/icon_location.png";
    if (hasContent) {
      buttonText = _locationBean.address;
    }

    return BaseTagWidget(
      buttonText: buttonText,
      buttonImageProvider: AssetImage(
        buttonImageName,
        package: 'app_info_choose_kit',
      ),
      contentWidgetWhenShowDelete: Text(
        buttonText,
        maxLines: 1,
        style: TextStyle(
          fontSize: 12.w_pt_cj,
          color: const Color(0xFFFFA54C),
          fontWeight: FontWeight.w400,
        ),
      ),
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
        setState(() {});
      },
    );
  }

  void _clearLocation(BuildContext context) {
    _locationBean = null;
    setState(() {});
  }
}
