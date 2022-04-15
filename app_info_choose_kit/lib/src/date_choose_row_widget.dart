import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';
export 'package:flutter_datepicker/flutter_datepicker.dart' show ErrorDateType;

import '../app_info_choose_kit_adapt.dart';

class ActionDateChooseRowWidget extends StatefulWidget {
  String title;
  String value;
  String dateString;
  String minDateString;
  String maxDateString;
  void Function(ErrorDateType errorDateType)
      prohibitChangeDateBlock; // 禁止改变日期时候的回调
  void Function(String newValueString) onChooseCompleteBlock;

  ActionDateChooseRowWidget({
    Key key,
    @required this.title,
    @required
        this.value, // 值可能为"请选择日期"，但弹出来的时候需要到指定的初始日期(一般value=dateString)，即默认值不一定是必选
    @required this.dateString,
    this.minDateString,
    this.maxDateString,
    @required this.prohibitChangeDateBlock, // 禁止改变日期时候的回调
    @required this.onChooseCompleteBlock,
  }) : super(key: key);

  @override
  State<ActionDateChooseRowWidget> createState() =>
      _ActionDateChooseRowWidgetState();
}

class _ActionDateChooseRowWidgetState extends State<ActionDateChooseRowWidget> {
  String _value;
  String _dateString;
  String _minDateString;
  String _maxDateString;
  @override
  void initState() {
    super.initState();

    _value = widget.value ?? "";
    _dateString = widget.dateString;
    _minDateString = widget.minDateString;
    _maxDateString = widget.maxDateString;
  }

  @override
  Widget build(BuildContext context) {
    return DateChooseWidget(
      title: widget.title,
      dateString: _value,
      onChooseHandel: () {
        DatePickerUtil.chooseyyyyMMddFuture(
          context,
          selectedyyyyMMddDateString: _dateString,
          minDateString: _minDateString,
          maxDateString: _maxDateString,
          errorDateBlock: (errorDateType) {
            widget.prohibitChangeDateBlock(errorDateType);
            return;
          },
          onConfirm: (yyyyMMddDateStirng) {
            _dateString = yyyyMMddDateStirng;
            _value = _dateString;
            widget.onChooseCompleteBlock(_value);
            setState(() {});
          },
        );
      },
    );
  }
}

class DateChooseWidget extends StatelessWidget {
  String title;
  String value;
  String dateString;
  void Function() onChooseHandel;

  DateChooseWidget({
    Key key,
    @required this.title,
    @required this.value, // 值可能为"请选择日期"，但弹出来的时候需要到指定的初始日期(一般value=dateString)
    @required this.dateString,
    @required this.onChooseHandel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h_pt_cj,
      margin: EdgeInsets.only(left: 15.w_pt_cj, right: 15.w_pt_cj),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.w_pt_cj),
        border: Border.all(color: Color(0xFFFF7F00), width: 1.w_pt_cj),
      ),
      child: Row(
        children: [
          SizedBox(width: 5.w_pt_cj),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                title ?? "",
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 15.w_pt_cj,
                ),
              ),
            ),
          ),
          SizedBox(width: 5.w_pt_cj),
          Expanded(
            child: InkWell(
              onTap: () {
                onChooseHandel();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  dateString,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15.w_pt_cj,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5.w_pt_cj),
        ],
      ),
    );
  }
}
