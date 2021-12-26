// ignore_for_file: file_names

class ResultData {
  var data;
  bool isSuccess;
  int code;
  String msg;
  var headers;

  ResultData(this.data, this.isSuccess, this.code,this.msg, {this.headers});
}
