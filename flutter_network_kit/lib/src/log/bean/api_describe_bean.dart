/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-07 16:46:42
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
    List<String> mentioned_list = [];
    for (String apiApiPeople in apiApiPeoples ?? []) {
      mentioned_list.add(apiApiPeople);
    }

    for (ApiPeopleBean appApiPeople in appApiPeoples ?? []) {
      mentioned_list.add(appApiPeople.pid);
    }
    // mentioned_list = ['lichaoqian'];
    return mentioned_list;
  }
}
