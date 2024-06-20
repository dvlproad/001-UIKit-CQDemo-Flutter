/*
 * @Author: dvlproad
 * @Date: 2024-05-15 17:25:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-15 17:44:09
 * @Description: 
 */
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';

class PickerTimeUtils {
  static bool isTimeSamePre(PDuration date1, PDuration date2, DateMode mode) {
    if (mode == DateMode.Y) {
      return date1.year == date2.year;
    } else if (mode == DateMode.YM) {
      return date1.year == date2.year && date1.month == date2.month;
    } else if (mode == DateMode.YMD) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    } else if (mode == DateMode.YMDH) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day &&
          date1.hour == date2.hour;
    } else if (mode == DateMode.YMDHM) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day &&
          date1.hour == date2.hour &&
          date1.minute == date2.minute;
    }
    return false;
  }

  /// 分 和 秒
  static List calcMinAndSecond({int begin = 0, int end = 59, int? multiple}) {
    begin = begin < 0 ? 0 : begin;
    end = end > 59 ? 59 : end;
    return _calcCount(begin, end, multiple: multiple);
  }

  static List _calcCount(begin, end, {int? multiple}) {
    if (multiple != null) {
      List<int> array = [];
      for (int i = begin; i <= end; i++) {
        if (i % multiple == 0) {
          array.add(i);
        }
      }
      return array;
    }

    int length = end - begin + 1;
    if (length == 0) return [begin];
    if (length < 0) return [];

    return List.generate(length, (index) => begin + index);
  }
}
