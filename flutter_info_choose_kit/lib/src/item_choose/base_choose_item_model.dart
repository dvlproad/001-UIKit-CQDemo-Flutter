/*
 * @Author: dvlproad
 * @Date: 2024-05-07 11:28:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-15 11:14:48
 * @Description: 
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

class BaseChooseItemUtil {
  static void clickItemIndex<T extends BaseChooseItemModel>(
    int itemIndex, {
    required int maxChooseCount, // 最大选择数量(1代表单选)
    required List<T> sourceItems,
    required List<T> currentSelectedItems,
    required void Function(int count)? beyondMaxChooseCount,
    required void Function(List<T> selectedItemModels) onValueChange,
  }) {
    T item = sourceItems[itemIndex];
    // 1、判断点击是之前选中的还是新选中的
    T? hasChoosedItem;
    try {
      hasChoosedItem =
          currentSelectedItems.firstWhere((element) => element.id == item.id);
    } catch (e) {
      hasChoosedItem = null;
    }
    if (hasChoosedItem != null) {
      // 点击的 item 之前已选中
      currentSelectedItems.remove(hasChoosedItem);
    } else {
      // 点击的 item 之前未选中
      // ① 如果是单选
      if (maxChooseCount == 1) {
        currentSelectedItems.clear();
      } else {
        // ② 多选，如果是执行选中，提前判断是否会超过
        if (currentSelectedItems.length >= maxChooseCount) {
          // 如果是多选又超过最大个数
          beyondMaxChooseCount?.call(currentSelectedItems.length);
          return;
        }
      }
      currentSelectedItems.add(item);
    }
    onValueChange(currentSelectedItems);
  }
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

class BaseChoosedItemUtil {
  static void clickChooseItemIndex<T extends BaseChoosedItemModel>(
    int itemIndex, {
    required int maxChooseCount, // 最大选择数量(1代表单选)
    required List<T> sourceItems,
    required void Function(int count)? beyondMaxChooseCount,
    required void Function(List<T> selectedItemModels) onValueChange,
  }) {
    List<T> currentSelectedItems = [];
    for (var element in sourceItems) {
      if (element.choosed) {
        currentSelectedItems.add(element);
      }
    }

    T item = sourceItems[itemIndex];
    // 1、判断点击是之前选中的还是新选中的
    T? hasChoosedItem;
    try {
      hasChoosedItem =
          currentSelectedItems.firstWhere((element) => element.id == item.id);
    } catch (e) {
      hasChoosedItem = null;
    }
    if (hasChoosedItem != null) {
      // 点击的是之前的值
      hasChoosedItem.choosed = !hasChoosedItem.choosed;
      if (hasChoosedItem.choosed) {
        // 如果是单选
        if (maxChooseCount == 1) {
          for (var element in currentSelectedItems) {
            element.choosed = false;
          }
          currentSelectedItems.clear();
        }
        currentSelectedItems.add(hasChoosedItem);
      } else {
        currentSelectedItems.remove(hasChoosedItem);
      }
    } else {
      // 如果是单选
      if (maxChooseCount == 1) {
        for (var element in currentSelectedItems) {
          element.choosed = false;
        }
        currentSelectedItems.clear();
      } else {
        // 多选，如果是执行选中，提前判断是否会超过
        if (item.choosed == false &&
            currentSelectedItems.length >= maxChooseCount) {
          // 如果是多选又超过最大个数
          beyondMaxChooseCount?.call(currentSelectedItems.length);
          return;
        }
      }

      item.choosed = !item.choosed;
      if (item.choosed) {
        currentSelectedItems.add(item);
      } else {
        currentSelectedItems.remove(item);
      }
    }
    onValueChange(currentSelectedItems);

    // if (_maxChooseCount == 1) {
    //   // 单选
    //   T? oldSelectedItem =
    //       currentSelectedItems?.first;
    //   if (oldSelectedItem?.id == item.id) {
    //     //
    //   } else {
    //     if (oldSelectedItem != null) {
    //       oldSelectedItem.choosed = !oldSelectedItem.choosed;
    //     }
    //     item.choosed = !item.choosed;
    //     oldSelectedItem = item;
    //   }
    // } else {
    //   // 多选
    //   item.choosed = !item.choosed;
    // }
  }
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