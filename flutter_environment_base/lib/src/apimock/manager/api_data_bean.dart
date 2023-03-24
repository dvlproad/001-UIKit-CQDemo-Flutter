/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 14:11:27
 * @Description: 
 */
class ApiModel {
  String name;
  String url;
  bool mock; // 是否mock

  ApiModel({
    this.name = '',
    required this.url,
    this.mock = false,
  });

  @override
  String toString() => '$url $mock';

  // json 与 model 转换
  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
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
