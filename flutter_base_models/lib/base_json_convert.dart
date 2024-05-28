/*
 * @Author: dvlproad
 * @Date: 2024-05-11 11:47:51
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-11 16:35:56
 * @Description: 
 */
// import 'package:flutter/foundation.dart';

abstract class BaseJsonConvert<T> {
  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T model);
}

/* 使用示例
class PersonModel {
  final String name;
  final int age;
  final String email;
  PersonModel({required this.name, required this.age, required this.email});
}

// 定义一个 converter 而不是 子类
class PersonJsonConvert extends BaseJsonConvert<PersonModel> {
  @override
  PersonModel fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }

  @override
  Map<String, dynamic> toJson(PersonModel model) {
    return {
      'name': model.name,
      'age': model.age,
      'email': model.email,
    };
  }
}

class Demo {
  void testJsonConvert() {
    var json = {
      'name': '张三',
      'age': 20,
      'email': 'zhangsan@example.com',
    };
    PersonModel personModel = PersonJsonConvert().fromJson(json);
    Map<String, dynamic> json2 = PersonJsonConvert().toJson(personModel);
    debugPrint("json2: $json2");
  }
}
*/
