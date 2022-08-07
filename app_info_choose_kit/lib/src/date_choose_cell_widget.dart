/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-02 10:56:32
 * @Description: 日期选择的Cell
 */
import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';
export 'package:flutter_datepicker/flutter_datepicker.dart' show ErrorDateType;

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';

class ActionDateChooseCellWidget extends StatefulWidget {
  ImageProvider imageProvider;
  String title;
  DatePickerType datePickerType;
  String realChooseDateString;
  String recommendDateString;
  String minDateString;
  String maxDateString;
  void Function(ErrorDateType errorDateType)
      prohibitChangeDateBlock; // 禁止改变日期时候的回调
  void Function(String newValueString) onChooseCompleteBlock;

  ActionDateChooseCellWidget({
    Key key,
    this.imageProvider,
    @required this.title,
    this.datePickerType,
    @required
        this.realChooseDateString, // 值可能为"请选择日期"，但弹出来的时候需要到指定的初始日期(一般value=dateString)，即默认值不一定是必选
    @required this.recommendDateString,
    this.minDateString,
    this.maxDateString,
    @required this.prohibitChangeDateBlock, // 禁止改变日期时候的回调
    @required this.onChooseCompleteBlock,
  }) : super(key: key);

  @override
  State<ActionDateChooseCellWidget> createState() =>
      _ActionDateChooseCellWidgetState();
}

class _ActionDateChooseCellWidgetState
    extends State<ActionDateChooseCellWidget> {
  String _realChooseDateString;
  String _minDateString;
  String _maxDateString;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _realChooseDateString = widget.realChooseDateString ?? "";
    _minDateString = widget.minDateString;
    _maxDateString = widget.maxDateString;

    return AppImageTitleTextValueCell(
      title: widget.title ?? '',
      imageProvider: AssetImage(
        'assets/icon_date.png',
        package: 'app_info_choose_kit',
      ),
      textValue: _realChooseDateString ?? '',
      textValuePlaceHodler: '点击选择',
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());

        String dateString;
        if (_realChooseDateString == null || _realChooseDateString.isEmpty) {
          if (widget.recommendDateString != null &&
              widget.recommendDateString.isNotEmpty) {
            dateString = widget.recommendDateString;
          } else {
            dateString = _realChooseDateString;
          }
        } else {
          dateString = _realChooseDateString;
        }
        DatePickerUtil.chooseyyyyMMddFuture(
          context,
          datePickerType: widget.datePickerType,
          selectedyyyyMMddDateString: dateString,
          minDateString: _minDateString,
          maxDateString: _maxDateString,
          errorDateBlock: (errorDateType) {
            widget.prohibitChangeDateBlock(errorDateType);
            return;
          },
          onConfirm: (yyyyMMddDateStirng) {
            _realChooseDateString = yyyyMMddDateStirng;
            widget.onChooseCompleteBlock(_realChooseDateString);
          },
        );
      },
    );
  }
}
