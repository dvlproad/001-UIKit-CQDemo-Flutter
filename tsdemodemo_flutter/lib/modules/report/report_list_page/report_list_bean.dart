import 'dart:convert' show json;

class ReportBean {

  String id;
  String message;
  List<ReportBean> rows;

  ReportBean.fromParams({this.id, this.message, this.rows});

  factory ReportBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? ReportBean._fromJson(json.decode(jsonStr)) : ReportBean._fromJson(jsonStr);

  ReportBean._fromJson(jsonRes) {
    id = jsonRes['id'];
    message = jsonRes['message'];
    rows = jsonRes['rows'] == null ? null : [];

    for (var rowsItem in rows == null ? [] : jsonRes['rows']){
      rows.add(rowsItem == null ? null : ReportBean._fromJson(rowsItem));
    }
  }

  //ReportBean()


  @override
  String toString() {
    return '{"id": ${id != null?'${json.encode(id)}':'null'},"message": ${message != null?'${json.encode(message)}':'null'},"rows": $rows}';
  }
}


