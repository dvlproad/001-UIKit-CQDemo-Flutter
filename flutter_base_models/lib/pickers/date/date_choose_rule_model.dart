// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-05-23 10:52:11
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 11:05:50
 * @Description: 
 */

/// 时间选择器 所显示样式
enum DatePickerType {
  /// 【yyyy-MM-dd】年月日
  YMD,

  /// 【yyyy-MM】年月
  YM,

  /// 【MM-dd】月日
  MD,

  /// 【HH:mm】时分
  HM,
}

class DateChooseBaseBean {
  DatePickerType? datePickerType;
  String? minDate; // 该标签允许改变到的最小值
  String? maxDate; // 该标签允许改变到的最大值
  String? recommendChooseDate; // 推荐建议的选中日期
  String? realChooseDate; // 真正的选中的日期(有推荐不代表一定要选)

  bool? allowChangeDefaultDate; // 是否允许改变日期

  DateChooseBaseBean({
    this.datePickerType,
    this.minDate,
    this.maxDate,
    this.recommendChooseDate,
    this.realChooseDate,
    // this.forceChooseDefaultDate,
    this.allowChangeDefaultDate,
  });

  bool get hasDate {
    return recommendChooseDate != null && recommendChooseDate!.isNotEmpty;
  }

  bool get isyyyyMMdd {
    int dateStringLength = recommendChooseDate?.length ?? 0;
    return dateStringLength == 10; // 2022-01-01
  }

  bool get isMMdd {
    int dateStringLength = recommendChooseDate?.length ?? 0;
    return dateStringLength == 5; // 01-01
  }
}

class DateChooseBean extends DateChooseBaseBean {
  String? dateDescribe;

  DateChooseBean({
    DatePickerType? datePickerType,
    String? minDate, // 该标签允许改变到的最小值
    String? maxDate, // 该标签允许改变到的最大值
    String? recommendChooseDate, // 推荐建议的选中日期
    String? realChooseDate, // 真正的选中的日期(有推荐不代表一定要选)
    bool? allowChangeDefaultDate, // 是否允许改变日期
    this.dateDescribe,
  }) : super(
          datePickerType: datePickerType,
          minDate: minDate,
          maxDate: maxDate,
          recommendChooseDate: recommendChooseDate,
          realChooseDate: realChooseDate,
          allowChangeDefaultDate: allowChangeDefaultDate,
        );
}
