import '../user/address/address_list_entity.dart';
import '../user/user_event.dart';
// import 'package:wish/ui/class/mine/member/model/member_info_model.dart';
import './user_base_bean.dart';

class User_manager_bean extends UserBaseBean {
  String authToken;
  // bool isTokenOvdue;
  String id;
  String accountName;
  String tel;
  bool privacy_mode;
  int control;

  String address;
  int anchorNo;
  int areaId;
  String auditState;
  String authMode;
  String authNo;
  String birthday;
  bool hasBirthDayUpdate;
  String cardBack;
  String cardFront;
  String cardNum;
  int cityId;
  String createUserId;
  String gmtCreate;
  String gmtModified;
  String handCard;
  String intro;
  String modifyUserId;
  int provinceId;
  int levelValue;
  String remark;
  int sex;
  int state;
  String userSource;
  String userType;
  //6.22补充
  String area;
  String city;
  int isShowAddressTag;
  int isShowAgeTag;
  int isShowConstellationTag;
  int isShowProfessionTag;
  int isShowSchoolTag;
  int isShowSexTag;
  String levelId;
  String levelName;
  String profession;
  String professionDictCode; //职业code
  String province;
  String school;
  String schoolDictCode; //学校code
  String entranceSchoolTime;
  bool hasWishPush;
  bool hasFace;
  int avatarStatus; //头像活体状态 1: 初始化 2: 人脸检测不通过 4: 人脸通过 16: 活体通过
  int authFlag;
  int matchConsumerType;
  List<String> hobbyTagList;

  // 其他参数
  List<AddressListEntity> addressModels = [];
  AddressListEntity defaultAddressModel;
  // Member_info_model memberModel; //会员信息
  // List<CollectWishEntity> wishCollectList = []; // 愿望单收藏
  // List<GoodsCollectEntity> goodsCollectList = []; // 商品收藏
  // List<BrandCollectEntity> brandCollectList = []; // 品牌收藏

  // String get id => _id ?? "";
  // bool get privacy_mode => _privacy_mode ??= false;
  // String get tel => _tel ?? "";

  User_manager_bean({
    this.id,
    this.accountName,
    this.authToken,
    // this.isTokenOvdue,
    this.tel = "",
    this.privacy_mode = false,
    this.control,
    this.address,
    this.anchorNo,
    this.areaId,
    this.auditState,
    this.authMode,
    this.authNo,
    this.birthday,
    this.hasBirthDayUpdate,
    this.cardBack,
    this.cardFront,
    this.cardNum,
    this.cityId,
    this.createUserId,
    this.gmtCreate,
    this.gmtModified,
    this.handCard,
    this.intro,
    this.modifyUserId,
    this.provinceId,
    this.levelValue,
    this.remark,
    this.sex,
    this.state,
    this.userSource,
    this.userType,
    // 其他信息
    this.addressModels,
    this.defaultAddressModel,
    //6.22补充
    this.area,
    this.city,
    this.isShowAddressTag,
    this.isShowAgeTag,
    this.isShowConstellationTag,
    this.isShowProfessionTag,
    this.isShowSchoolTag,
    this.isShowSexTag,
    this.levelId,
    this.levelName,
    this.profession,
    this.professionDictCode,
    this.province,
    this.school,
    this.schoolDictCode,
    this.entranceSchoolTime,
    this.hasWishPush,
    this.hasFace,
    this.avatarStatus,
    this.authFlag,
    this.hobbyTagList,
    this.matchConsumerType,
    String userId,
    String nickname,
    String avatar,
    int consumerLevel,
  }) : super(
          userId: userId,
          avatar: avatar,
          nickname: nickname,
          consumerLevel: consumerLevel,
        );

  User_manager_bean.fromJson(Map<String, dynamic> json) {
    UserBaseBean userBaseBean = UserBaseBean.fromJson(json);
    this.userId = userBaseBean.userId;
    this.avatar = userBaseBean.avatar;
    this.nickname = userBaseBean.nickname;
    this.consumerLevel = userBaseBean.consumerLevel;

    if (json["id"] is String) this.id = json["id"];
    if (json["accountName"] is String) this.accountName = json["accountName"];

    if (json["headerValue"] is String) this.authToken = json["headerValue"];

    if (json["privacy_mode"] is bool) {
      this.privacy_mode = json["privacy_mode"];
    } else {
      this.privacy_mode = false;
    }
    if (json["tel"] is String) this.tel = json["tel"];

    if (json["address"] is String) this.address = json["address"];
    if (json["anchorNo"] is int) this.anchorNo = json["anchorNo"];
    if (json["control"] is int) this.control = json["control"];
    if (json["areaId"] is int) this.areaId = json["areaId"];
    if (json["auditState"] is String) this.auditState = json["auditState"];
    if (json["authMode"] is String) this.authMode = json["authMode"];
    if (json["authNo"] is String) this.authNo = json["authNo"];
    if (json["birthday"] is String) this.birthday = json["birthday"];
    hasBirthDayUpdate = json["hasBirthDayUpdate"] ?? false;
    if (json["cardBack"] is String) this.cardBack = json["cardBack"];
    if (json["cardFront"] is String) this.cardFront = json["cardFront"];
    if (json["cardNum"] is String) this.cardNum = json["cardNum"];
    if (json["cityId"] is int) this.cityId = json["cityId"];
    if (json["createUserId"] is String)
      this.createUserId = json["createUserId"];
    if (json["gmtCreate"] is String) this.gmtCreate = json["gmtCreate"];
    if (json["gmtModified"] is String) this.gmtModified = json["gmtModified"];
    if (json["handCard"] is String) this.handCard = json["handCard"];
    if (json["intro"] is String) this.intro = json["intro"];
    if (json["modifyUserId"] is String)
      this.modifyUserId = json["modifyUserId"];
    if (json["provinceId"] is int) this.provinceId = json["provinceId"];
    if (json["levelValue"] is int) this.levelValue = json["levelValue"];
    if (json["remark"] is String) this.remark = json["remark"];
    if (json["sex"] is int) this.sex = json["sex"];
    if (json["state"] is int) this.state = json["state"];
    if (json["userSource"] is String) this.userSource = json["userSource"];
    if (json["userType"] is String) this.userType = json["userType"];
    //6.22补充
    if (json["area"] is String) this.area = json["area"];
    if (json["city"] is String) this.city = json["city"];
    if (json["isShowAddressTag"] is int)
      this.isShowAddressTag = json["isShowAddressTag"];
    if (json["isShowAgeTag"] is int) this.isShowAgeTag = json["isShowAgeTag"];
    if (json["isShowConstellationTag"] is int)
      this.isShowConstellationTag = json["isShowConstellationTag"];
    if (json["isShowProfessionTag"] is int)
      this.isShowProfessionTag = json["isShowProfessionTag"];
    if (json["isShowSchoolTag"] is int)
      this.isShowSchoolTag = json["isShowSchoolTag"];
    if (json["isShowSexTag"] is int) this.isShowSexTag = json["isShowSexTag"];
    if (json["levelId"] is String) this.levelId = json["levelId"];
    if (json["levelName"] is String) this.levelName = json["levelName"];
    if (json["profession"] is String) this.profession = json["profession"];
    if (json["professionDictCode"] is String)
      this.professionDictCode = json["professionDictCode"];
    if (json["province"] is String) this.province = json["province"];
    if (json["school"] is String) this.school = json["school"];
    if (json["schoolDictCode"] is String)
      this.schoolDictCode = json["schoolDictCode"];
    if (json["entranceSchoolTime"] is String)
      this.entranceSchoolTime = json["entranceSchoolTime"];
    if (json["hasWishPush"] is bool) this.hasWishPush = json["hasWishPush"];
    if (json["hasFace"] is bool) this.hasFace = json["hasFace"];
    if (json["avatarStatus"] is int) this.avatarStatus = json["avatarStatus"];
    if (json["authFlag"] is int) this.authFlag = json["authFlag"];
    if (json["hobbyTagList"] != null) {
      hobbyTagList = json['hobbyTagList'].cast<String>();
    } else {
      hobbyTagList = [];
    }
    this.matchConsumerType = json["matchConsumerType"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data["id"] = this.id;
    data["accountName"] = this.accountName;
    data["headerValue"] = this.authToken;
    data["privacy_mode"] = this.privacy_mode;
    data["control"] = this.control;
    data["tel"] = this.tel;

    data["address"] = this.address;
    data["anchorNo"] = this.anchorNo;
    data["areaId"] = this.areaId;
    data["auditState"] = this.auditState;
    data["authMode"] = this.authMode;
    data["authNo"] = this.authNo;
    data["birthday"] = this.birthday;
    data["hasBirthDayUpdate"] = hasBirthDayUpdate ?? false;
    data["cardBack"] = this.cardBack;
    data["cardFront"] = this.cardFront;
    data["cardNum"] = this.cardNum;
    data["cityId"] = this.cityId;
    data["createUserId"] = this.createUserId;
    data["gmtCreate"] = this.gmtCreate;
    data["gmtModified"] = this.gmtModified;
    data["handCard"] = this.handCard;
    data["intro"] = this.intro;
    data["modifyUserId"] = this.modifyUserId;
    data["provinceId"] = this.provinceId;
    data["levelValue"] = this.levelValue;
    data["remark"] = this.remark;
    data["sex"] = this.sex;
    data["state"] = this.state;
    data["userSource"] = this.userSource;
    data["userType"] = this.userType;
    //6.22补充
    data["area"] = this.area;
    data["city"] = this.city;
    data["isShowAddressTag"] = this.isShowAddressTag;
    data["isShowAgeTag"] = this.isShowAgeTag;
    data["isShowConstellationTag"] = this.isShowConstellationTag;
    data["isShowProfessionTag"] = this.isShowProfessionTag;
    data["isShowSchoolTag"] = this.isShowSchoolTag;
    data["isShowSexTag"] = this.isShowSexTag;
    data["levelId"] = this.levelId;
    data["levelName"] = this.levelName;
    data["profession"] = this.profession;
    data["professionDictCode"] = this.professionDictCode;
    data["province"] = this.province;
    data["school"] = this.school;
    data["schoolDictCode"] = this.schoolDictCode;
    data["entranceSchoolTime"] = this.entranceSchoolTime;
    data["hasWishPush"] = this.hasWishPush;
    data["hasFace"] = this.hasFace;
    data["avatarStatus"] = this.avatarStatus;
    data["authFlag"] = this.authFlag;
    data['hobbyTagList'] = this.hobbyTagList;
    data['matchConsumerType'] = this.matchConsumerType;
    return data;
  }

  // 是否是登录状态
  bool get hasLogin {
    var uid = id; // 兼容null
    if (null != uid && uid.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool get isTokenOvdue => authToken == 'token_overdue';

  UserLoginState get loginState {
    if (hasLogin) {
      if (isTokenOvdue) {
        return UserLoginState.overdue;
      }
      return UserLoginState.logined;
    } else {
      return UserLoginState.unlogin;
    }
  }
}
