import 'package:flutter/material.dart';
import 'package:app_map/app_map.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';

class LocationChooseCellWidget extends StatefulWidget {
  LocationBean locationBean;
  void Function({LocationBean bLocationBean}) valueChangeBlock;
  LocationChooseCellWidget({
    Key key,
    this.locationBean,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<LocationChooseCellWidget> createState() =>
      _LocationChooseCellWidgetState();
}

class _LocationChooseCellWidgetState extends State<LocationChooseCellWidget> {
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

    return ImageTitleTextValueCell(
      title: '定位',
      imageProvider: AssetImage(
        'assets/icon_location.png',
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
