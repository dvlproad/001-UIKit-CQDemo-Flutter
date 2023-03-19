/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 19:19:34
 * @Description: 
 */
import 'package:flutter/material.dart';
import './jurisdiction_bean.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';

class JurisdictionChooseCellWidget extends StatefulWidget {
  final double leftRightPadding; // cell 内容的左右间距(未设置时候，默认20)
  JurisdictionBean jurisdictionBean;
  final List<JurisdictionBean> thankTypeModels; // 可选择的感谢方式
  void Function({JurisdictionBean bLocationBean}) valueChangeBlock;

  JurisdictionChooseCellWidget({
    Key key,
    this.leftRightPadding,
    this.jurisdictionBean,
    @required this.thankTypeModels,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<JurisdictionChooseCellWidget> createState() =>
      JurisdictionChooseCellWidgetState();
}

class JurisdictionChooseCellWidgetState
    extends State<JurisdictionChooseCellWidget> {
  JurisdictionBean _jurisdictionBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    // _jurisdictionBean = widget.jurisdictionBean;
  }

  // updateLocationBean(JurisdictionBean jurisdictionBean) {
  //   setState(() {
  //     _jurisdictionBean = jurisdictionBean;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _jurisdictionBean = widget.jurisdictionBean;
    bool hasContent = _jurisdictionBean != null;

    return AppImageTitleTextValueCell(
      leftRightPadding: widget.leftRightPadding,
      title: '可见范围',
      imageProvider: AssetImage(
        'assets/icon_jurisdiction.png',
        package: 'app_info_choose_kit',
      ),
      textValue: _jurisdictionBean?.text,
      textValuePlaceHodler: '点击选择',
      onTap: () {
        _addJurisdictionType(context);
      },
    );
  }

  void _addJurisdictionType(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
