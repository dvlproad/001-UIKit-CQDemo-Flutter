import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:date_format/date_format.dart';
import './showModal_util.dart';
import './pickercreater.dart';

typedef PickerConfirmCityCallback = void Function(
    List<String> stringData, List<int> selecteds);

class DatePickerUtil {
  static void chooseBirthday(
    BuildContext context, {
    String title,
    String selectedyyyyMMddDateString,
    @required void Function(String yyyyMMddDateStirng) onConfirm,
  }) {
    DateTime selectedyyyyMMddDate;
    if (selectedyyyyMMddDateString != null) {
      DateTime yyyyMMddDate = DateTime.parse(selectedyyyyMMddDateString);
      selectedyyyyMMddDate = yyyyMMddDate;
    }

    DatePickerUtil.chooseDate(
      context,
      title: title,
      value: selectedyyyyMMddDate,
      minValue: DateTime(DateTime.now().year - 150),
      maxValue: DateTime.now(),
      onConfirm: (Picker picker, List<int> selected) {
        //print(selected);
        DateTime dateTime = (picker.adapter as DateTimePickerAdapter).value;

        String yyyyMMddDateString =
            formatDate(dateTime, ['yyyy', '-', 'mm', '-', 'dd']);

        print(yyyyMMddDateString);
        if (onConfirm != null) {
          onConfirm(yyyyMMddDateString);
        }
      },
    );
  }

  ///日期选择器
  static void chooseDate(
    BuildContext context, {
    String title,
    DateTime maxValue,
    DateTime minValue,
    DateTime value,
    @required PickerConfirmCallback onConfirm,
  }) {
    Picker picker = getDatePicker(
      title: title,
      maxValue: maxValue,
      minValue: minValue,
      value: value,
      selecteds: null,
      onConfirm: onConfirm,
    );

    ShowModalUtil.showInBottom(
      context: context, //state.context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return getDatePickerWidget(picker);
      },
    );
  }

  static Widget getDatePickerWidget(Picker picker) {
    return picker.makePicker(null, true);
    /*
    return Container(
      color: Colors.blue,
      height: 308,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        // fit: StackFit.expand,
        children: [
          // Container(
          //   color: Colors.purple.withOpacity(0.2),
          //   height: 260,
          // ),
          picker.makePicker(null, true),
          Positioned(
            top: 100,
            child: Row(
              children: [
                Container(
                  color: Colors.green.withOpacity(0.5),
                  height: 60,
                  width: 200,
                  // width: double.infinity,
                  // height: double.infinity,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: Text("第一个组件2"),
                ),
              ],
            ),
          ),
          // picker.makePicker(null, true),
        ],
      ),
    );
    */
  }

  static Picker getDatePicker({
    String title,
    DateTime maxValue,
    DateTime minValue,
    DateTime value,
    List<int> selecteds,
    @required PickerConfirmCallback onConfirm,
  }) {
    PickerAdapter adapter = DateTimePickerAdapter(
      type: PickerDateTimeType.kYMD,
      isNumberMonth: true,
      yearSuffix: "年",
      maxValue: maxValue ?? DateTime(2030, 12, 31),
      minValue: minValue ?? DateTime(1990, 1, 1),
      value: value ?? DateTime.now(),
      monthSuffix: "月",
      daySuffix: "日",
    );

    Picker picker = PickerCreaterUtil.getPicker(
      title: title,
      adapter: adapter,
      selecteds: selecteds,
      onConfirm: onConfirm,
    );

    return picker;
  }
}
