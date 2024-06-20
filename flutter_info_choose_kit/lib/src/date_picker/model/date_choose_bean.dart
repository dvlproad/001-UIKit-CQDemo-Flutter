/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 11:05:41
 * @Description: 日期默认值及其选择规则
 */
import 'package:flutter_base_models/flutter_base_models.dart';

class DateChooseRuleBean extends DateChooseBaseBean {
  // bool showDateChooseView; // 是否显示日期选择视图(可以的话，才有如下对应规则)
  bool? forceChooseDefaultDate;

  DateChooseRuleBean({
    // this.showDateChooseView,
    DatePickerType? datePickerType,
    String? minDate, // 该标签允许改变到的最小值
    String? maxDate, // 该标签允许改变到的最大值
    String? recommendChooseDate, // 推荐建议的选中日期
    bool? allowChangeDefaultDate, // 是否允许改变日期

    this.forceChooseDefaultDate,
  }) : super(
          datePickerType: datePickerType,
          minDate: minDate,
          maxDate: maxDate,
          recommendChooseDate: recommendChooseDate,
          realChooseDate:
              forceChooseDefaultDate == true ? recommendChooseDate : null,
          allowChangeDefaultDate: allowChangeDefaultDate,
        );

  DateChooseRuleBean.fromJson(dynamic json) {
    // showDateChooseView = json['dateMode'] == 0 ? false : true;
    if (json['dateMode'] == 2) {
      datePickerType = DatePickerType.MD;
    } else {
      datePickerType = DatePickerType.YMD;
    }

    minDate = json['minDate'];
    maxDate = json['maxDate'];
    recommendChooseDate = json['defaultDate'];
    forceChooseDefaultDate = json['requiredDate'] == 1 ? true : false;
    allowChangeDefaultDate = json['modifyDate'] == 1; // 是否可修改日期(0:否;1:是)
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dateMode'] = datePickerType == DatePickerType.MD ? 2 : 1;
    map['minDate'] = minDate;
    map['maxDate'] = maxDate;
    map['defaultDate'] = recommendChooseDate;
    map['requiredDate'] = forceChooseDefaultDate;
    map['modifyDate'] =
        allowChangeDefaultDate == true ? 1 : 0; // 是否可修改日期(0:否;1:是)

    return map;
  }
}
