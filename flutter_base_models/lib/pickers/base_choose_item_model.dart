/*
 * @Author: dvlproad
 * @Date: 2024-05-07 11:28:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 13:29:41
 * @Description: 可选择的事项（【话题】、【用户关系(同学、朋友)】）
 */
class BaseChooseItemModel {
  final String id;
  final String name;
  // bool choosed; // 为了避免点击之后，没有选择确认，则导致数据源变更，所以基础模型上不应加此字段

  BaseChooseItemModel({
    required this.id,
    required this.name,
    // required this.choosed,
  });
}

/*
class BaseChoosedItemModel extends BaseChooseItemModel {
  bool choosed; // 外部要修改

  BaseChoosedItemModel({
    required String id,
    required String name,
    bool choosed = false,
  }) : super(
          id: id,
          name: name,
        );
}
*/


/*
class AppActivityTagModel extends BaseChooseItemModel {
  AppActivityTagModel({
    required String id,
    required String name,
    bool choosed = false,
  }) : super(
          id: id,
          name: name,
          choosed: choosed,
        );

  static AppActivityTagModel fromJson(Map<String, dynamic> json) {
    String id;
    if (json['id'] is int) {
      id = json['id'].toString();
    } else {
      id = json['id'];
    }

    return AppActivityTagModel(
      id: id,
      name: json['name'],
      choosed: json['choosed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'choosed': choosed,
    };
  }
}
*/