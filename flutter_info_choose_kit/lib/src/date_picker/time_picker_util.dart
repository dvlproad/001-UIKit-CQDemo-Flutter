/*
 * @Author: dvlproad
 * @Date: 2024-05-06 13:53:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-06-20 18:30:18
 * @Description: 
 */
import 'package:flutter/material.dart';
// import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import './fork_flutter_pickers/pickers.dart';

import '../../../flutter_info_choose_kit_adapt.dart';

// extension

class TimePickerUtil {
  // ignore: non_constant_identifier_names
  static void chooseTime_MDHMS({
    required BuildContext context,
    bool unitInTop = false, // 单位单独使用一行并且位于顶部
    String? title,
    required int maxShowDays, // 最多显示几天(包含今天)
    String? selectedMMddHHSSDateString,
    required void Function(String resultMMddHHSSDateString) onConfirm,
  }) {
    /*
    // 将 "05-09 08:38" 转换为 "2024-05-09T08:38:00.000Z" 格式的日期时间字符串
    String inputDateTime = '05-09 08:38';
    inputDateTime = DateTime.now().year.toString() + "-" + inputDateTime;
    // 将输入的日期时间字符串解析为日期对象
    DateTime parsedDateTime =
        DateFormat('yyyy-MM-dd HH:mm').parse(inputDateTime);
    // 将日期对象格式化为目标日期时间字符串
    String outputDateTime =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'').format(parsedDateTime);
    debugPrint(outputDateTime); // 输出：2024-05-09T08:38:00.000Z
    return;
    */
    DateTime selectedDateTime = DateTime.now();
    if (selectedMMddHHSSDateString != null) {
      selectedDateTime =
          DateTime.parse("${DateTime.now().year}-$selectedMMddHHSSDateString");
    }
    PDuration selectedDate = PDuration.parse(selectedDateTime);

    DateTime now = DateTime.now();
    // now = DateTime.utc(now.year, now.month, now.day, 14, 46, 0); // 测试时间

    DateTime minDate = now;
    if (now.minute > 45) {
      minDate = now.add(Duration(minutes: 60 - now.minute));
    }

    DateTime maxDate = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);
    maxDate = maxDate.add(Duration(days: maxShowDays - 1));

    double menuHeight = 36.0;
    Widget headMenuView = Container(
      // color: Colors.grey[50],
      color: Colors.white,
      height: menuHeight,
      child: Row(
        children: [
          Expanded(child: Center(child: _renderText('月'))),
          Expanded(child: Center(child: _renderText('日'))),
          Expanded(child: Center(child: _renderText('时'))),
          Expanded(child: Center(child: _renderText('分'))),
        ],
      ),
    );

    // 选择时间的逻辑
    ForkPickers.showDatePicker(
      context,
      mode: DateMode.MDHM,
      minuteMultiple: 15,
      pickerStyle: unitInTop == true
          ? PickerStyle(
              menu: headMenuView,
              menuHeight: menuHeight,
              title: title != null && title.isNotEmpty
                  ? Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.f_pt_cj,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    )
                  : null,
            )
          : null,
      suffix: unitInTop == true
          ? Suffix(month: '', days: '', hours: '', minutes: '')
          : Suffix.normal(),
      minDate: PDuration.parse(minDate),
      maxDate: PDuration.parse(maxDate),
      // minDate: PDuration(year: 2024, month: 2, day: 10),
      // maxDate: PDuration(second: 22),

      selectDate: selectedDate,
      // minDate: PDuration(hour: 12, minute: 38, second: 3),
      // maxDate: PDuration(hour: 12, minute: 40, second: 36),
      onConfirm: (p) {
        // debugPrint('longer >>> 返回数据：$p');

        String monthString = p.month.toString().padLeft(2, "0");
        String dayString = p.day.toString().padLeft(2, "0");
        String hourString = p.hour.toString().padLeft(2, "0");
        String minuteString = p.minute.toString().padLeft(2, "0");
        String resultMMddHHSSDateString =
            '$monthString-$dayString $hourString:$minuteString';
        onConfirm(resultMMddHHSSDateString);
      },
      // onChanged: (p) => print(p),
    );
  }

  static _renderText(String? data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        data ?? "null",
        style: TextStyle(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.bold,
          color: const Color(0xFF333333),
          fontSize: 14.f_pt_cj,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
