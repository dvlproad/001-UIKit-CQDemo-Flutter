/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 19:46:47
 * @Description: 位置选择tag视图
 */
import 'package:flutter/material.dart';
import './thank_type_model.dart';
import './thanks_util.dart';

import '../app_info_choose_kit_adapt.dart';
import './base_tag_widget.dart';

class ThanksChooseTagWidget extends StatefulWidget {
  final double width;
  final BoxConstraints constraints;
  final bool shouldExpandedButtonText;

  ThankTypeModel thanksTypeBean;
  final List<ThankTypeModel> thankTypeModels; // 可选择的感谢方式
  void Function({ThankTypeModel bLocationBean}) valueChangeBlock;

  ThanksChooseTagWidget({
    Key key,
    this.width,
    this.constraints,
    this.shouldExpandedButtonText,
    this.thanksTypeBean,
    @required this.thankTypeModels,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<ThanksChooseTagWidget> createState() => ThanksChooseTagWidgetState();
}

class ThanksChooseTagWidgetState extends State<ThanksChooseTagWidget> {
  ThankTypeModel _thanksTypeBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _thanksTypeBean = widget.thanksTypeBean;
  }

  @override
  Widget build(BuildContext context) {
    bool hasContent = _thanksTypeBean != null;
    String buttonText = '感谢方式';
    String buttonImageName = "assets/icon_thanks.png";
    if (hasContent) {
      buttonText = _thanksTypeBean.mainLabel;
    }

    return BaseTagWidget(
      width: widget.width,
      shouldExpandedButtonText: widget.shouldExpandedButtonText,
      constraints: widget.constraints,
      buttonText: buttonText,
      buttonImageProvider: AssetImage(
        buttonImageName,
        package: 'app_info_choose_kit',
      ),
      contentWidgetWhenShowDelete: BaseTagText(buttonText),
      onTap: () {
        if (hasContent == false) {
          _addThanksType(context);
        } else {
          _addThanksType(context);
        }
      },
      showDeleteIcon: !hasContent ? false : true,
      onTapDelete: () {
        _clearLocation(context);
      },
    );
  }

  void _addThanksType(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    ThanksUtil.show(
      context,
      selectedThankTypeModel: _thanksTypeBean,
      thankTypeModels: widget.thankTypeModels,
      chooseCompleteBlock: ({ThankTypeModel bThankTypeModel}) {
        _thanksTypeBean = bThankTypeModel;
        if (widget.valueChangeBlock != null) {
          widget.valueChangeBlock(bLocationBean: _thanksTypeBean);
        }
      },
    );
  }

  void _clearLocation(BuildContext context) {
    _thanksTypeBean = null;
    if (widget.valueChangeBlock != null) {
      widget.valueChangeBlock(bLocationBean: _thanksTypeBean);
    }
  }
}
