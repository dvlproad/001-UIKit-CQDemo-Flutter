/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-17 17:31:02
 * @Description: 地址选择cell
 */
import 'package:flutter/material.dart';
import './address/address_util.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';
import 'package:app_service_user/app_service_user.dart';

class AddressChooseCellWidget extends StatefulWidget {
  final Color color;
  final double leftRightPadding;
  final AddressListEntity addressModel;
  final void Function({AddressListEntity bAddressModel}) valueChangeBlock;

  AddressChooseCellWidget({
    Key key,
    this.color,
    this.leftRightPadding,
    this.addressModel,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<AddressChooseCellWidget> createState() =>
      _AddressChooseCellWidgetState();
}

class _AddressChooseCellWidgetState extends State<AddressChooseCellWidget> {
  AddressListEntity _addressModel;
  bool _isPlay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _addressModel = widget.addressModel;
    bool hasContent = _addressModel != null;

    return AppImageTitleTextValueCell(
      color: widget.color,
      leftRightPadding: 0,
      leftMaxWidth: 130,
      title: '收货信息',
      imageProvider: AssetImage(
        'assets/icon_logistics.png',
        package: 'app_info_choose_kit',
      ),
      textValue: _addressModel?.address,
      textValuePlaceHodler: '点击选择',
      onTap: () {
        _addAddress(context);
      },
    );
  }

  void _addAddress(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    AddressUtil.goChooseAddressPage(
      context,
      selectedAddressModel: _addressModel,
      chooseCompleteBlock: ({bAddressModel}) {
        _addressModel = bAddressModel;
        if (widget.valueChangeBlock != null) {
          widget.valueChangeBlock(bAddressModel: _addressModel);
        }
        setState(() {});
      },
    );
  }

  void _clearAddress(BuildContext context) {
    _addressModel = null;
    if (widget.valueChangeBlock != null) {
      widget.valueChangeBlock(bAddressModel: _addressModel);
    }
    setState(() {});
  }
}
