enum LogLevel {
  normal, // 正常信息
  success, // 成功信息(目前用于请求成功)
  warning, // 警告信息
  error, // 错误日志
}

class LogModel {
  String title;
  String content;
  LogLevel logLevel;
  Map logInfo;

  LogModel({
    this.title = '',
    this.content,
    this.logLevel = LogLevel.normal,
    this.logInfo, // 用来标识处理的log特殊数据
  });

  @override
  String toString() => '$title $content';

  // json 与 model 转换
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      title: json['title'],
      content: json['content'],
      logLevel: json['logLevel'],
      logInfo: json['logInfo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": this.title,
      "content": this.content,
      "logLevel": this.logLevel,
      "logInfo": this.logInfo,
    };
  }
}
