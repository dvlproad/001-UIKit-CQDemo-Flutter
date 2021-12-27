class ApiModel {
  String name;
  String url;
  bool mock; // 是否mock

  ApiModel({
    this.name = '',
    this.url,
    this.mock = false,
  });

  @override
  String toString() => '$url $mock';
}
