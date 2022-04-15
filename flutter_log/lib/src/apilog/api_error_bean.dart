/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-16 03:27:14
 * @Description: Api报错信息(含 描述、api人、app人)
 */
// 人
class ApiPeopleBean {
  String pid;

  ApiPeopleBean({
    this.pid,
  });
}

// 问题(含 描述、api人、app人)
class ApiErrorDesBean {
  final String des;
  final List<String> apiApiPeoples;
  final List<ApiPeopleBean> appApiPeoples;

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
