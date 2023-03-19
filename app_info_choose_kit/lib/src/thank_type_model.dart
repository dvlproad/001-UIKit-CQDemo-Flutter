import 'dart:convert';
import 'package:app_network/app_network.dart';

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class ThankTypeModel {
  ThankTypeModel({
    this.id,
    this.mainLabel,
  }) {
    originId = TraceUtil.traceId();
  }

  factory ThankTypeModel.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : ThankTypeModel(
          id: asT<String>(json['_id']),
          mainLabel: asT<String>(json['main_label']),
        );

  String id;
  String mainLabel;

  /// 由于后台两个接口用的是不同语言写的，则需要用此字段关联感谢方式与愿望单
  /// /wish/create and /front-node/feedback/create
  String originId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  operator ==(other) => other is ThankTypeModel && other.id == id;

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': id,
        'main_label': mainLabel,
      };

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
