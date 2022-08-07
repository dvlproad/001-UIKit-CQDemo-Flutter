import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_pickers/style/picker_style.dart';

// flutter_pickers
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';

import 'package:date_format/date_format.dart';
import './showModal_util.dart';
import './pickercreater.dart';

import './model/date_choose_bean.dart';
export './model/date_choose_bean.dart';

typedef PickerConfirmCityCallback = void Function(
    List<String> stringData, List<int> selecteds);

enum ErrorDateType {
  maxLessThanMin, // 最大日期小于最小日期
  maxEqualToMin, // 最大日期等于最小日期
}

class DatePickerUtil {
  // // 根据日期选择范围判断日期是否可修改
  // static bool prohibitChangeDate(String minDateString, String maxDateString) {
  //   if (minDateString != null &&
  //       minDateString.isNotEmpty &&
  //       maxDateString != null &&
  //       maxDateString.isNotEmpty) {
  //     if (minDateString == maxDateString) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

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

  static void chooseyyyyMMddFuture(
    BuildContext context, {
    DatePickerType
        datePickerType, // 日期选择类型，为null时候，会取selectedyyyyMMddDateString来判断，若也为null，则默认年月日格式
    String title,
    String selectedyyyyMMddDateString,
    String minDateString,
    String maxDateString,
    void Function(ErrorDateType errorDateType) errorDateBlock, // 检查到日期错误的回调
    @required void Function(String yyyyMMddDateStirng) onConfirm,
  }) {
    DateTime selectedyyyyMMddDate =
        DateFormatterUtil.fromDateString(selectedyyyyMMddDateString) ??
            DateTime.now();
    DateTime minDateTime = DateFormatterUtil.fromDateString(minDateString);
    DateTime maxDateTime = DateFormatterUtil.fromDateString(maxDateString);
    if (minDateTime != null && maxDateString != null) {
      int compareResult =
          maxDateTime.compareTo(minDateTime); // 大于返回1；等于返回0；小于返回-1
      if (compareResult == 0) {
        if (errorDateBlock != null) {
          errorDateBlock(ErrorDateType.maxEqualToMin);
        }
        return;
      } else if (compareResult == -1) {
        if (errorDateBlock != null) {
          errorDateBlock(ErrorDateType.maxLessThanMin);
        }
        print("Error：日期错误，最大日期不能小于最小日期，请检查");
        return;
      }
    }

    DateMode dateMode = DateMode.YMD;
    if (datePickerType == null) {
      int dateStringLength = selectedyyyyMMddDateString?.length ?? 0;
      bool isDateStringNoYear = dateStringLength == 5; // 01-01
      dateMode = isDateStringNoYear == false ? DateMode.YMD : DateMode.MD;
    } else {
      if (datePickerType == DatePickerType.MD) {
        dateMode = DateMode.MD;
      } else {
        dateMode = DateMode.YMD;
      }
    }

    Pickers.showDatePicker(
      context,
      pickerStyle: PickerStyle(
        title: Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.only(left: 10),
          child: Text(
            '请填写真实生日',
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
      mode: dateMode,
      selectDate: selectedyyyyMMddDate == null
          ? null
          : PDuration.parse(selectedyyyyMMddDate),
      minDate: minDateTime == null ? null : PDuration.parse(minDateTime),
      maxDate: maxDateTime == null ? null : PDuration.parse(maxDateTime),
      suffix: Suffix(years: "年", month: "月", days: "日"),
      onConfirm: (p) {
        String yyyyMMddDateString;

        String yearString = "${p.year}";
        String monthString = p.month.toString().padLeft(2, "0");
        String dayString = p.day.toString().padLeft(2, "0");
        if (datePickerType == DatePickerType.MD) {
          yyyyMMddDateString = "$monthString-$dayString";
        } else {
          yyyyMMddDateString = "$yearString-$monthString-$dayString";
        }

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

class DateFormatterUtil {
  /// 将日期字符串转成日期(支持 2022-01-01 及 01-01 格式，后者会自动补上当前年，传null或空字符串或请填写日期等非日期格式时候，会无法解析，返回null)
  static DateTime fromDateString(String selectedyyyyMMddDateString) {
    DateTime selectedyyyyMMddDate;
    // "请选择日期" 不满足 日期格式，则使用当前日期
    if (selectedyyyyMMddDateString == null ||
        selectedyyyyMMddDateString.isEmpty ||
        selectedyyyyMMddDateString.indexOf("-") == -1) {
      selectedyyyyMMddDate = null;
    } else {
      if (selectedyyyyMMddDateString.length == 5) {
        // 01-01
        int year = DateTime.now().year;
        selectedyyyyMMddDateString = "$year-$selectedyyyyMMddDateString";
      }

      if (selectedyyyyMMddDateString != null) {
        DateTime yyyyMMddDate = DateTime.parse(selectedyyyyMMddDateString);
        selectedyyyyMMddDate = yyyyMMddDate;
      }
    }

    return selectedyyyyMMddDate;
  }
}
