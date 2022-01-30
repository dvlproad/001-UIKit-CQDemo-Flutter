enum LogLevel {
  normal, // 正常信息
  warning, // 警告信息
  error, // 错误日志
}

class LogModel {
  String name;
  String url;
  bool mock; // 是否mock
  LogLevel logLevel;

  LogModel({
    this.name = '',
    this.url,
    this.mock = false,
    this.logLevel = LogLevel.normal,
  });

  @override
  String toString() => '$url $mock';

  // json 与 model 转换
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      name: json['name'],
      url: json['url'],
      mock: json['mock'],
      logLevel: json['logLevel'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "url": this.url,
      "mock": this.mock,
      "logLevel": this.logLevel,
    };
  }
}
