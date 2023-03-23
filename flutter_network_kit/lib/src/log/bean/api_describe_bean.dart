/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:11:39
 * @Description: Api的描述信息模型(含 接口描述、api负责人、app负责人)
 */
import './api_user_bean.dart';

class ApiErrorDesBean {
  final String? des;
  final List<String>? apiApiPeoples;
  final List<ApiPeopleBean>? appApiPeoples;

  ApiErrorDesBean({
    this.des,
    this.apiApiPeoples,
    this.appApiPeoples,
  });

  List<String> allPids() {
    List<String> mentionedList = [];
    for (String apiApiPeople in apiApiPeoples ?? []) {
      mentionedList.add(apiApiPeople);
    }

    for (ApiPeopleBean appApiPeople in appApiPeoples ?? []) {
      mentionedList.add(appApiPeople.pid);
    }
    return mentionedList;
  }
}
