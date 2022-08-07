/*
 * @Author: dvlproad
 * @Date: 2022-04-15 14:43:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-02 19:36:59
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart'
    show DateChooseRuleBean;
import './base_tag_model.dart';

import 'package:wish/route/route_manager.dart';
import 'package:wish/service/user/user_manager.dart';

class SelectedTagInfo<T extends BaseTagModel> extends BaseTagModel {
  String customValue;

  // SelectedTagInfo({
  //   @required String id,
  //   String tagName,
  //   TagChooseDateAction actionType,
  //   DateChooseRuleBean dateChooseBean,
  //   List<BaseTagModel> children,
  //   int defalutChildIndex,
  //   this.customValue,
  // }) : super(
  //         id: id,
  //         tagName: tagName,
  //         actionType: actionType,
  //         dateChooseBean: dateChooseBean,
  //         children: children,
  //         defalutChildIndex: defalutChildIndex,
  //       ) {}

  SelectedTagInfo.fromBaseTagModel({
    @required T baseTagModel,
    this.customValue,
  }) : super(
        // id: id,
        ) {
    id = baseTagModel.id;
    tagName = baseTagModel.tagName;
    actionType = baseTagModel.actionType;
    dateChooseBean = baseTagModel.dateChooseBean;
    children = baseTagModel.children;
    defalutChildIndex = baseTagModel.defalutChildIndex;
  }

  SelectedTagInfo.fromJson(dynamic json) {
    BaseTagModel baseTagModel = BaseTagModel.fromJson(json);
    id = baseTagModel.id;
    tagName = baseTagModel.tagName;
    actionType = baseTagModel.actionType;
    dateChooseBean = baseTagModel.dateChooseBean;
    children = baseTagModel.children;
    defalutChildIndex = baseTagModel.defalutChildIndex;

    customValue = json['customValue'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['customValue'] = customValue;

    return map;
  }
}

class TagModel extends BaseTagModel {
  String tagBg;
  String tagColor;
  String tagIcon;
  String tagTitle;
  String tagScene; // tag场景
  SelectedTagInfo selectedLeafTagInfo;
  bool isChoose;

  TagModel({
    @required String id,
    String tagName,
    TagChooseDateAction actionType,
    DateChooseRuleBean dateChooseBean,
    List<BaseTagModel> children,
    int defalutChildIndex,
    this.tagBg,
    this.tagColor,
    this.tagIcon,
    this.tagTitle,
    this.tagScene, // tag场景
    this.selectedLeafTagInfo,
    this.isChoose,
  }) : super(
          id: id,
          tagName: tagName,
          actionType: actionType,
          dateChooseBean: dateChooseBean,
          children: children,
          defalutChildIndex: defalutChildIndex,
        ) {}

  static TagModel fromBaseTagModel(BaseTagModel baseTagModel) {
    TagModel tagModel = TagModel.fromJson(baseTagModel.toJson());
    return tagModel;
  }

  TagModel.fromJson(dynamic json) {
    BaseTagModel baseTagModel = BaseTagModel.fromJson(json);
    id = baseTagModel.id;
    tagName = baseTagModel.tagName;
    actionType = baseTagModel.actionType;

    dateChooseBean = baseTagModel.dateChooseBean;
    children = baseTagModel.children;
    defalutChildIndex = baseTagModel.defalutChildIndex;

    tagBg = json['tagBg'];
    tagColor = json['tagColor'];
    tagIcon = json['tagIcon'];
    tagTitle = json['tagTitle'];
    tagScene = json['scene'];
    if (tagScene == 'birth' && dateChooseBean.recommendChooseDate == null) {
      String birthday = UserInfoManager().userModel.birthday;
      dateChooseBean.recommendChooseDate = birthday;
    }

    isChoose = false;
  }

  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['tagBg'] = tagBg;
    map['tagColor'] = tagColor;
    map['tagIcon'] = tagIcon;
    map['tagTitle'] = tagTitle;
    map['scene'] = tagScene;

    return map;
  }

  String get fullShowValue {
    return showInfo["fullShowValue"];
  }

  String get showDateString {
    return showInfo["showDateString"];
  }

  Map<String, dynamic> get showInfo {
    Map<String, dynamic> showInfoMap = TagModel._getTagShowValueByLeafTagId(
      parentTagModel: this,
      selectedLeafTagInfo: this.selectedLeafTagInfo,
    );
    return showInfoMap;
  }

  List<int> get selectedLeafFullIndexPaths {
    if (selectedLeafTagInfo == null) {
      return null;
    }
    List<int> fullLeafIndexPaths = BaseTagModel.getLeafTagModelPathByLeafTagId(
      parentTagModel: this,
      leafTagId: this.selectedLeafTagInfo.id,
    );
    return fullLeafIndexPaths;
  }

  static Map<String, dynamic> _getTagShowValueByLeafTagId({
    @required TagModel parentTagModel,
    @required SelectedTagInfo selectedLeafTagInfo, // 选中的叶子节点
  }) {
    if (selectedLeafTagInfo == null) {
      return {
        "fullShowValue": parentTagModel.tagName,
        "leafIndexPaths": [0],
      };
    }
    String selectedLeafTagId = selectedLeafTagInfo.id;
    String selectedLeafTagCustomDate = selectedLeafTagInfo.customValue;

    BaseTagModel selectedChildBaseTagModel =
        BaseTagModel.getLeafTagModelByLeafTagId(
      parentTagModel: parentTagModel,
      leafTagId: selectedLeafTagId,
    );
    // TagModel selectedChildTagModel = selectedChildBaseTagModel as TagModel;
    TagModel selectedChildTagModel =
        TagModel.fromBaseTagModel(selectedChildBaseTagModel);

    String showDateString;
    String fullShowValue;
    String fullTagName = selectedChildTagModel.tagName;
    int index = fullTagName.indexOf('愿望');
    String shortTagName = fullTagName;
    if (index != -1) {
      shortTagName = fullTagName.substring(0, index);
    }
    if (selectedLeafTagCustomDate != null) {
      showDateString = selectedLeafTagCustomDate;
      fullShowValue = "$shortTagName:$showDateString";

      return {
        "showDateString": showDateString,
        "fullShowValue": fullShowValue,
      };
    } else {
      if (selectedChildTagModel.dateChooseBean != null &&
          selectedChildTagModel.dateChooseBean.recommendChooseDate != null) {
        String recommendChooseDate =
            selectedChildTagModel.dateChooseBean.recommendChooseDate;
        showDateString = recommendChooseDate;
        fullShowValue = "$shortTagName:$showDateString";
        return {
          "showDateString": showDateString,
          "fullShowValue": fullShowValue,
        };
      } else {
        fullShowValue = "$fullTagName";
        return {
          "fullShowValue": fullShowValue,
        };
      }
    }
  }
}
