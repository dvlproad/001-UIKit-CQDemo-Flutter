/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-12 18:00:44
 * @Description: 
 */
import 'package:flutter/material.dart';
import './thank_type_model.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';
import './thanks_util.dart';

class ThanksChooseCellWidget extends StatefulWidget {
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  ThankTypeModel thanksTypeBean;
  final List<ThankTypeModel> thankTypeModels; // 可选择的感谢方式
  void Function({ThankTypeModel bLocationBean}) valueChangeBlock;

  ThanksChooseCellWidget({
    Key key,
    this.leftRightPadding,
    this.thanksTypeBean,
    @required this.thankTypeModels,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<ThanksChooseCellWidget> createState() => ThanksChooseCellWidgetState();
}

class ThanksChooseCellWidgetState extends State<ThanksChooseCellWidget> {
  ThankTypeModel _thanksTypeBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    // _thanksTypeBean = widget.thanksTypeBean;
  }

  // updateLocationBean(ThankTypeModel thanksTypeBean) {
  //   setState(() {
  //     _thanksTypeBean = thanksTypeBean;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _thanksTypeBean = widget.thanksTypeBean;
    bool hasContent = _thanksTypeBean != null;

    return AppImageTitleTextValueCell(
      leftRightPadding: widget.leftRightPadding,
      title: '感谢方式',
      imageProvider: AssetImage(
        'assets/icon_thanks.png',
        package: 'app_info_choose_kit',
      ),
      textValue: _thanksTypeBean?.mainLabel,
      textValuePlaceHodler: '点击选择',
      onTap: () {
        _addThanksType(context);
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
        setState(() {});
      },
    );
  }

  void _clearLocation(BuildContext context) {
    _thanksTypeBean = null;
    if (widget.valueChangeBlock != null) {
      widget.valueChangeBlock(bLocationBean: _thanksTypeBean);
    }
    setState(() {});
  }
}
