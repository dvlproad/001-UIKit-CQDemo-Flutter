/*
 * @Author: dvlproad
 * @Date: 2022-08-29 15:55:11
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 11:30:12
 * @Description: 内容、时间、地点、人物
 */
import 'package:flutter_image_process/flutter_image_process.dart'
    show ImageChooseBean, VoiceBaseBean;

import '../location/nearby_or_picker_adderss_model.dart';
import '../pickers/base_choose_item_model.dart';
import '../pickers/date/date_choose_rule_model.dart';
import './jurisdiction_bean.dart';

enum PublishState {
  def,
  uploadStart,
  uploading,
  uploadSuccess,
  uploadFail,
  cancel,
  dealing,
  success,
  fail,
  auditFail,
  createFail
}

class BasePublishModel<
    TMedia extends ImageChooseBean,
    TVoice extends VoiceBaseBean,
    TTag extends BaseChooseItemModel,
    TTopic,
    TUser> {
  // 内容id(更新的时候才有此值)
  String? wishId;

  /// 1、内容
  // 文本
  String? publishTitle;
  String? publishDescribe;
  List<String>? messageAtUserIds; // message 中 @ 的好友
  // 图片
  List<TMedia>? imageChooseModels;
  // 封面
  ImageChooseBean? coverImageChooseModel;
  // 语音
  TVoice? uploadVoiceBean;
  // 标签
  List<TTag>? selectedActivityTagModels;
  // 话题
  List<TTopic>? topicList;

  // 2、时间(日期)
  DateChooseBean? dateChooseBean; // 日期默认值及其选择规则
  // String? activityMMDDHHSSTimeString;
  String? dateChooseString;

  /// 3、地点
  // 用户指定的位置（poi 或者 区域)
  NearbyOrAreaPickerAddressModel? locationBean;

  // 4、其他（权限）
  JurisdictionType? jurisdictionType;
  List<TUser>? selectUsers;

  BasePublishModel({
    this.wishId,
    this.publishTitle,
    this.publishDescribe,
    this.messageAtUserIds,
    this.imageChooseModels,
    this.coverImageChooseModel,
    this.uploadVoiceBean,
    this.selectedActivityTagModels,
    this.topicList,
    this.dateChooseBean,
    this.dateChooseString,
    this.locationBean,
    this.jurisdictionType,
    this.selectUsers,
  });

  /// 检查是否存在
  bool get exsitTag =>
      selectedActivityTagModels != null &&
      selectedActivityTagModels!.isNotEmpty;
  bool get exsitDescribe =>
      publishDescribe != null && publishDescribe!.isNotEmpty;
  bool get exsitImages =>
      imageChooseModels != null && imageChooseModels!.isNotEmpty;
  bool get exsitDate =>
      dateChooseString != null && dateChooseString!.isNotEmpty;
  bool get exsitSpecialAddress => locationBean != null;
  // bool get exsitVoice => uploadVoiceBean != null;

  /*
  BasePublishModel fromCacheJson(Map<String, dynamic> json) {
    String? wishId = json['wishId'];

    // 文本
    String? publishTitle = json['publishTitle'];
    String? publishDescribe = json['publishDescribe'];
    List<String>? messageAtUserIds =
        json['messageAtUserIds']; // message 中 @ 的好友
    // 图片
    PickPhotoAllowType? pickAllowType = json['pickAllowType'];
    List<TMedia>? imageChooseModels = json['imageChooseModels'];
    // 封面
    ImageChooseBean? coverImageChooseModel = json['coverImageChooseModel'];
    // 语音
    VoiceBean? uploadVoiceBean = json['uploadVoiceBean'];
    // 标签
    List<TTag>? selectedActivityTagModels = json['selectedActivityTagModels'];
    // 话题
    List<TTopic>? topicList = json['topicList'];

    // 2、时间(日期)
    DateChooseBean? dateChooseBean = json['dateChooseBean']; // 日期默认值及其选择规则
    // String? activityMMDDHHSSTimeString;
    String? dateChooseString = json['dateChooseString'];

    /// 3、地点
    // 用户指定的位置（poi 或者 区域)
    NearbyOrAreaPickerAddressModel? locationBean = json['locationBean'];

    // 4、其他（权限）
    JurisdictionType? jurisdictionType;
    List<TUser> selectUsers = [];
    return BasePublishModel(
      wishId: wishId,
      publishTitle: publishTitle,
      publishDescribe: publishDescribe,
      messageAtUserIds: messageAtUserIds,
      pickAllowType: pickAllowType,
      imageChooseModels: imageChooseModels,
      coverImageChooseModel: coverImageChooseModel,
      uploadVoiceBean: uploadVoiceBean,
      selectedActivityTagModels: selectedActivityTagModels,
      topicList: topicList,
      dateChooseBean: dateChooseBean,
      dateChooseString: dateChooseString,
      locationBean: locationBean,
      jurisdictionType: jurisdictionType,
      selectUsers: selectUsers,
    );
  }

  /// 转成 json 形式，用于2保存草稿
  Map<String, dynamic> toCacheJson() {
    Map<String, dynamic> data = {};
    if (wishId != null) {
      data['wishId'] = wishId;
    }
    // 文本
    if (publishTitle != null) {
      data['publishTitle'] = publishTitle;
    }
    if (publishDescribe != null) {
      data['publishDescribe'] = publishDescribe;
    }
    if (messageAtUserIds != null) {
      data['messageAtUserIds'] = messageAtUserIds;
    }
    // 媒体（图片、封面、语音）
    if (imageChooseModels != null) {
      List<Map<String, dynamic>> imageChooseMaps = [];
      for (TMedia element in imageChooseModels!) {
        Map<String, dynamic> imageChooseMap = element.toJson();
        imageChooseMaps.add(imageChooseMap);
      }
      data['imageChooseModels'] = imageChooseMaps;
    }
    if (coverImageChooseModel != null) {
      Map<String, dynamic> coverImageMap = coverImageChooseModel!.toJson();
      data['coverImageChooseModel'] = coverImageMap;
    }
    if (uploadVoiceBean != null) {
      data['uploadVoiceBean'] = uploadVoiceBean!.toJson();
    }
    // 标签、话题
    if (selectedActivityTagModels != null) {
      List<Map<String, dynamic>> selectedTagMaps = [];
      for (TTag element in selectedActivityTagModels!) {
        Map<String, dynamic> imageChooseMap = element.toJson();
        selectedTagMaps.add(imageChooseMap);
      }
      data['selectedActivityTagModels'] = selectedTagMaps;
    }
    if (topicList != null) {
      List<Map<String, dynamic>> selectedTopicMaps = [];
      for (TTopic element in topicList!) {
        // Map<String, dynamic> imageChooseMap = element.toJson();
        Map<String, dynamic> imageChooseMap =
            TTopicJsonConvert().toJson(element);
        selectedTopicMaps.add(imageChooseMap);
      }
      data['topicList'] = selectedTopicMaps;
    }
    // 时间
    if (dateChooseBean != null) {
      data['dateChooseBean'] = dateChooseBean.toJson();
    }
    if (dateChooseString != null) {
      data['dateChooseString'] = dateChooseString;
    }
    // 地点
    if (locationBean != null) {
      data['locationBean'] = locationBean.toJson();
    }
    // 权限
    if (jurisdictionType != null) {
      data['jurisdictionType'] = jurisdictionType;
    }
    if (selectUsers != null) {
      List<Map<String, dynamic>> jurisdictionUserMaps = [];
      for (TUser element in selectUsers!) {
        Map<String, dynamic> jurisdictionUserMap = element.toJson();
        jurisdictionUserMaps.add(jurisdictionUserMap);
      }
      data['selectUsers'] = jurisdictionUserMaps;
    }

    return data;
  }
  */
}


/*
class AppPublishModel {
  //
}

class PublishJsonConvert extends BaseJsonConvert<AppPublishModel> {
  @override
  AppPublishModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(AppPublishModel model) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
*/
