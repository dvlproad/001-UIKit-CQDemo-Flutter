/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-02-03 11:24:14
 * @Description: 愿望单标签视图
 */
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datepicker/flutter_datepicker.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './mine_tag_model.dart';

import 'package:wish/route/route_manager.dart';
import 'package:app_network/app_network.dart';

import 'package:flutter_datepicker/flutter_datepicker.dart';
import 'package:app_service_user/app_service_user.dart';

export 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show ButtonImagePosition;

class MineTagView extends StatefulWidget {
  double width;
  double height;
  ButtonImagePosition imagePosition;

  TagModel tagModel;
  void Function(TagModel newTagModel)
      tagModelChangeBlock; // SelectedTagInfo selectedLeafTagInfo 通过 newTagModel 的属性返回

  MineTagView({
    Key key,
    this.width,
    this.height,
    this.imagePosition,
    @required this.tagModel,
    @required this.tagModelChangeBlock,
  }) : super(key: key);

  @override
  State<MineTagView> createState() => _MineTagViewState();
}

class _MineTagViewState extends State<MineTagView> {
  TagModel _tagModel;

  String _realChooseDateString;

  int _newListChooseIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tagModel = widget.tagModel;

    bool isSelected = _tagModel.isChoose == true;

    String title = widget.tagModel.fullShowValue;
    /*
    String title = _tagModel.tagName;
    if (_tagModel.actionType == TagChooseDateAction.byCustom) {
      if (_tagModel.realChooseDateString != null &&
          _tagModel.realChooseDateString.isNotEmpty) {
        int index = _tagModel.tagName.indexOf('愿望');
        String tagName;
        if (index == -1) {
          tagName = _tagModel.tagName;
        } else {
          tagName = _tagModel.tagName.substring(0, index);
        }

        String dateString = _tagModel.realChooseDateString;
        title = "$tagName:$dateString";
      } else {
        title = _tagModel.tagName;
      }
    } else if (_tagModel.actionType == TagChooseDateAction.fromList) {
      if (_tagModel.selectedChildIndex != -1) {
        TagModel selectedChildTagModel =
            _tagModel.children[_tagModel.selectedChildIndex];

        String tagName = selectedChildTagModel.tagName;
        String dateString =
            selectedChildTagModel.dateChooseBean.recommendChooseDate;
        title = "$tagName:$dateString";
      } else {
        title = _tagModel.tagName;
      }
    } else {
      title = _tagModel.tagName;
    }
    */

    return RichThemeStateButton(
      width: widget.width,
      height: widget.height,
      normalTitle: title,
      selectedTitle: title,
      titleStyle: TextStyle(
        fontFamily: 'PingFang SC',
        fontSize: 11.0.f_pt_cj,
        fontWeight: FontWeight.w400,
      ),
      imagePosition: widget.imagePosition,
      imageTitleGap: 2.w_pt_cj,
      imageWidget: Image(
        image: AssetImage(
          'assets/icon_arrow_down.png',
          package: 'app_info_choose_kit',
        ),
        width: 16.w_pt_cj,
        height: 16.h_pt_cj,
        fit: BoxFit.contain,
      ),
      cornerRadius: widget.height != null ? (widget.height / 2.0) : 6.w_pt_cj,
      richBGColorType: RichThemeStateBGType.grey_theme,
      selected: isSelected,
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());

        _clickTag();
      },
    );
  }

  _clickTag() {
    if (_tagModel.tagScene == 'birth') {
      String birthday = UserInfoManager().userModel.birthday;
      // String birthday = _tagModel.showDateString;
      bool hasBirthday = birthday != null && birthday.isNotEmpty;
      if (hasBirthday) {
        if (_tagModel.isChoose != true) {
          String customValue = birthday.substring(5, 10);
          _selectedLeafTag(
            leafBaseTagModel: _tagModel,
            leafTagCustomValue: customValue,
          );
        } else {
          RouteManager.pushPage(
            context,
            RouteNames.myInfoBirthdayPage,
            arguments: {
              "shouldShowPickerImmediately": false,
              "confirmFunction": (int year, int month, int day) {
                String newBirthday =
                    "${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";
                _selectedLeafTag(
                  leafBaseTagModel: _tagModel,
                  leafTagCustomValue: newBirthday,
                );
              },
            },
          );
        }
        return;
      } else {
        DateTime dateTime = DateTime.now();
        // String maxDateString = dateTime.toString().substring(0, 10);
        int year = dateTime.year - 18;
        int month = dateTime.month;
        int day = dateTime.day;

        String maxDateString =
            "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";

        DateChooseRuleBean dateChooseRuleBean = DateChooseRuleBean(
          datePickerType: DatePickerType.YMD,
          maxDate: maxDateString,
        );

        _tagModel.dateChooseBean = dateChooseRuleBean;
        // DatePickerUtil.chooseBirthday(
        //   context,
        //   title: '请填写真实生日',
        //   onConfirm: (yyyyMMddDateStirng) {
        //     // AppNetworkKit.post("user/info/update", params: {
        //     //   "birthday": yyyyMMddDateStirng,
        //     // });
        //   },
        // );
        _chooseDate(
          title: '请填写真实生日',
          onConfirm: (yyyyMMddDateStirng) {
            AppNetworkKit.post("user/info/update", params: {
              "birthday": yyyyMMddDateStirng,
            }).then((value) {
              UserInfoManager().userModel.birthday = yyyyMMddDateStirng;
            });

            setState(() {
              _realChooseDateString = yyyyMMddDateStirng.substring(5, 10);
            });
          },
        );
        return;
      }
    }

    if (_tagModel.actionType == TagChooseDateAction.none) {
      _selectedLeafTag(
        leafBaseTagModel: _tagModel,
        leafTagCustomValue: null,
      );
      return;
    }

    if (_tagModel.actionType == TagChooseDateAction.fromPicker) {
      _chooseDate();
      return;
    }

    List<int> fullLeafIndexPaths = _tagModel.selectedLeafFullIndexPaths;
    if (fullLeafIndexPaths != null && fullLeafIndexPaths.isNotEmpty) {
      _newListChooseIndex = fullLeafIndexPaths[0];
    } else {
      _newListChooseIndex = _tagModel.defalutChildIndex ?? 0;
    }
    _newListChooseIndex ??= 0;

    BrnMultiDataPicker(
      context: context,
      title: '选择节日',
      delegate: Brn1RowDelegate(
        tagModels: _tagModel.children,
        firstSelectedIndex: _newListChooseIndex,
        selectedIndexChangeBlock: (int newIndex) {
          _newListChooseIndex = newIndex;
        },
      ),
      confirmClick: (list) {
        BaseTagModel selectedTagModel = _tagModel.children[_newListChooseIndex];

        _selectedLeafTag(
          leafBaseTagModel: selectedTagModel,
          leafTagCustomValue: null,
        );
      },
    ).show();
  }

  _selectedLeafTag<T extends BaseTagModel>({
    @required T leafBaseTagModel,
    String leafTagCustomValue,
  }) {
    SelectedTagInfo selectedLeafTag = SelectedTagInfo.fromBaseTagModel(
      baseTagModel: leafBaseTagModel,
      customValue: leafTagCustomValue,
    );

    _tagModel.selectedLeafTagInfo = selectedLeafTag;
    if (widget.tagModelChangeBlock != null) {
      widget.tagModelChangeBlock(_tagModel);
    }
  }

  _chooseDate({
    String title, // 弹出框标题
    void Function(String yyyyMMddDateStirng) onConfirm, // 仅适用于生日标签
  }) {
    FocusScope.of(context).requestFocus(FocusNode());
    DateChooseRuleBean dateChooseRuleBean = _tagModel.dateChooseBean;

    String dateString;
    if (_realChooseDateString == null || _realChooseDateString.isEmpty) {
      if (dateChooseRuleBean.recommendChooseDate != null &&
          dateChooseRuleBean.recommendChooseDate.isNotEmpty) {
        dateString = dateChooseRuleBean.recommendChooseDate;
      } else {
        dateString = _realChooseDateString;
      }
    } else {
      dateString = _realChooseDateString;
    }

    DatePickerUtil.chooseyyyyMMddFuture(
      context,
      title: title,
      datePickerType: dateChooseRuleBean.datePickerType,
      selectedyyyyMMddDateString: dateString,
      minDateString: dateChooseRuleBean.minDate,
      maxDateString: dateChooseRuleBean.maxDate,
      errorDateBlock: (errorDateType) {
        ToastUtil.showMsg("该清单不可修改日期", context);
        return;
      },
      onConfirm: (yyyyMMddDateStirng) {
        _realChooseDateString = yyyyMMddDateStirng;
        // widget.onChooseCompleteBlock(_realChooseDateString);
        if (onConfirm != null) {
          onConfirm(yyyyMMddDateStirng);
        }

        _selectedLeafTag(
          leafBaseTagModel: _tagModel,
          leafTagCustomValue: _realChooseDateString,
        );
      },
    );
  }
}

class Brn1RowDelegate implements BrnMultiDataPickerDelegate {
  final List<BaseTagModel> tagModels;
  int firstSelectedIndex;

  final Function(int newIndex) selectedIndexChangeBlock;

  Brn1RowDelegate({
    @required this.tagModels,
    this.firstSelectedIndex = 0,
    @required this.selectedIndexChangeBlock,
  });

  @override
  int numberOfComponent() {
    return 1;
  }

  @override
  int numberOfRowsInComponent(int component) {
    return tagModels.length;
  }

  @override
  String titleForRowInComponent(int component, int index) {
    BaseTagModel tagModel = tagModels[index];
    String tagName = tagModel.tagName;
    String dateString = tagModel.dateChooseBean.recommendChooseDate;
    String title = "$tagName($dateString)";
    return title;
  }

  @override
  double rowHeightForComponent(int component) {
    return null;
  }

  @override
  selectRowInComponent(int component, int row) {
    firstSelectedIndex = row;
    print('firstSelectedIndex  is selected to $firstSelectedIndex');
    if (selectedIndexChangeBlock != null) {
      selectedIndexChangeBlock(row);
    }
  }

  @override
  int initSelectedRowForComponent(int component) {
    if (0 == component) {
      return firstSelectedIndex;
    }
    return 0;
  }
}
