/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-02 10:24:30
 * @Description: 地址选择cell
 */
import 'package:flutter/material.dart';
import './address/address_util.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';
import 'package:wish/service/user/address/address_list_entity.dart';

class AddressChooseCellWidget extends StatefulWidget {
  final double leftRightPadding;
  final AddressListEntity addressModel;
  final void Function({AddressListEntity bAddressModel}) valueChangeBlock;

  AddressChooseCellWidget({
    Key key,
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
      leftRightPadding: widget.leftRightPadding,
      leftMaxWidth: 130,
      title: '收货信息',
      imageProvider: AssetImage(
        'assets/icon_address.png',
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
