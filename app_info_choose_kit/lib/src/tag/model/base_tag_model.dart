/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-02 19:35:51
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';

enum TagChooseDateAction {
  none, // 此叶子节点无其他操作了
  fromPicker, // 自己选择日期(eg:生日)
  fromList, // 继续从子列表中选择
  fromCustom, // 完全自定义操作，并需要返回日期
}

class BaseTagModel {
  String id;
  String tagName;
  TagChooseDateAction actionType; // 是否可以选择日期(0:没有操作)
  DateChooseRuleBean dateChooseBean;

  List<BaseTagModel> children;
  int defalutChildIndex;

  BaseTagModel({
    @required this.id,
    this.tagName,
    this.actionType = TagChooseDateAction.none,
    this.dateChooseBean,
    this.children,
    this.defalutChildIndex,
  });

  BaseTagModel.fromJson(dynamic json) {
    id = json['id'];

    tagName = json['tagName'];

    if (json['dateFlag'] == 0) {
      actionType = TagChooseDateAction.none;
    } else {
      if (json['dateRule'] != null) {
        dateChooseBean = DateChooseRuleBean.fromJson(json['dateRule']);
      }
      if (json['children'] == null) {
        actionType = TagChooseDateAction.fromPicker;
      } else {
        actionType = TagChooseDateAction.fromList;
        children = [];

        defalutChildIndex = json['nearDateIndex'] ?? 0;

        for (var childJson in json['children']) {
          BaseTagModel tagModel = BaseTagModel.fromJson(childJson);
          children.add(tagModel);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = id;
    map['tagName'] = tagName;

    if (dateChooseBean != null) {
      map['dateRule'] = dateChooseBean.toJson();
    }

    // map['children'] =
    return map;
  }

  /// 根据叶子节点id，获取选中的标签节点完整信息
  static BaseTagModel getLeafTagModelByLeafTagId({
    @required BaseTagModel parentTagModel,
    @required String leafTagId,
  }) {
    if (parentTagModel.id == leafTagId) {
      return parentTagModel;
    } else {
      if (parentTagModel.children == null || parentTagModel.children.isEmpty) {
        return null;
      }

      for (var childTagModel in parentTagModel.children) {
        BaseTagModel leafTagModel = getLeafTagModelByLeafTagId(
          parentTagModel: childTagModel,
          leafTagId: leafTagId,
        );
        if (leafTagModel != null) {
          return leafTagModel;
        }
      }
    }
  }

  /// 根据叶子节点id，获取选中的标签节点的完整路径信息
  static List<int> getLeafTagModelPathByLeafTagId({
    @required BaseTagModel parentTagModel,
    @required String leafTagId,
  }) {
    if (parentTagModel.id == leafTagId) {
      return [0];
    } else {
      if (parentTagModel.children == null || parentTagModel.children.isEmpty) {
        return null;
      }

      List<int> fullLeafIndexPaths = [];
      int childTagCount = parentTagModel.children.length ?? 0;
      for (var i = 0; i < childTagCount; i++) {
        List<int> childLeafIndexPaths;
        var childTagModel = parentTagModel.children[i];

        if (childTagModel.id == leafTagId) {
          childLeafIndexPaths = [i];
        } else {
          childLeafIndexPaths = getLeafTagModelPathByLeafTagId(
            parentTagModel: childTagModel,
            leafTagId: leafTagId,
          );
        }

        if (childLeafIndexPaths != null) {
          fullLeafIndexPaths.addAll(childLeafIndexPaths);
          break;
        }
      }

      return fullLeafIndexPaths;
    }
  }

  bool containLeafTagId(String leafTagId) {
    if (leafTagId == null) {
      return false;
    }

    if (leafTagId == id) {
      return true;
    }

    if (children == null || children.isEmpty) {
      return false;
    }
    for (var item in children) {
      bool isContain = item.containLeafTagId(leafTagId);
      if (isContain == true) {
        return true;
      }
    }
    return false;
  }
}
