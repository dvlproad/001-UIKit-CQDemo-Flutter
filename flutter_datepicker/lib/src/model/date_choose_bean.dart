/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-02 21:03:18
 * @Description: 日期默认值及其选择规则
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

class DateChooseBean {
  String dateDescribe;
  DatePickerType datePickerType;
  String minDate; // 该标签允许改变到的最小值
  String maxDate; // 该标签允许改变到的最大值
  String recommendChooseDate; // 推荐建议的选中日期
  String realChooseDate; // 真正的选中的日期(有推荐不代表一定要选)

  bool allowChangeDefaultDate; // 是否允许改变日期

  DateChooseBean({
    this.dateDescribe,
    this.datePickerType,
    this.minDate,
    this.maxDate,
    this.recommendChooseDate,
    this.realChooseDate,
    // this.forceChooseDefaultDate,
    this.allowChangeDefaultDate,
  });

  /*
  DateChooseBean.fromJson(dynamic json) {
    dateDescribe = json['dateDescribe'] ?? '';
    minDate = json['minDate'] ?? '';
    maxDate = json['maxDate'] ?? '';
    recommendChooseDate = json['recommendChooseDate'] ?? '';
    realChooseDate = json['realChooseDate'] ?? '';
    // forceChooseDefaultDate = json['required'] ?? false;
    allowChangeDefaultDate = json['allowChangeDefaultDate'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dateDescribe'] = dateDescribe;
    map['minDate'] = minDate;
    map['maxDate'] = maxDate;
    map['recommendChooseDate'] = recommendChooseDate;
    map['realChooseDate'] = realChooseDate;
    // map['required'] = forceChooseDefaultDate;
    map['allowChangeDefaultDate'] = allowChangeDefaultDate;
    return map;
  }
  */

  bool get hasDate {
    return recommendChooseDate != null && recommendChooseDate.isNotEmpty;
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

class DateChooseRuleBean {
  // bool showDateChooseView; // 是否显示日期选择视图(可以的话，才有如下对应规则)

  DatePickerType datePickerType; // 时间选择器 所显示样式
  String minDate; // 该标签允许改变到的最小值
  String maxDate; // 该标签允许改变到的最大值
  String recommendChooseDate; // 推荐建议的选中日期
  bool forceChooseDefaultDate;

  bool allowChangeDefaultDate; // 是否允许改变日期

  DateChooseRuleBean({
    // this.showDateChooseView,
    this.datePickerType,
    this.minDate,
    this.maxDate,
    this.recommendChooseDate,
    this.forceChooseDefaultDate,
    this.allowChangeDefaultDate,
  });

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
    allowChangeDefaultDate =
        json['modifyDate'] == 1 ?? true; // 是否可修改日期(0:否;1:是)
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

  bool get hasDate {
    return recommendChooseDate != null && recommendChooseDate.isNotEmpty;
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
