class LogModel {
  String name;
  String url;
  bool mock; // 是否mock

  LogModel({
    this.name = '',
    this.url,
    this.mock = false,
  });

  @override
  String toString() => '$url $mock';

  // json 与 model 转换
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      name: json['name'],
      url: json['url'],
      mock: json['mock'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "url": this.url,
      "mock": this.mock,
    };
  }
}
