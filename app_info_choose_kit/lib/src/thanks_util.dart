/*
 * @Author: dvlproad
 * @Date: 2022-12-27 15:08:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-12 17:59:34
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:wish/widget/dialog/dialog_list_sheet.dart';
import 'package:wish/widget/rules_bottom_dialog.dart';
import './thank_type_model.dart';

class ThanksUtil {
  static void show(
    BuildContext context, {
    ThankTypeModel selectedThankTypeModel,
    @required List<ThankTypeModel> thankTypeModels,
    @required Function({ThankTypeModel bThankTypeModel}) chooseCompleteBlock,
  }) {
    PopupUtil.popupInBottom(context, popupViewBulider: (context) {
      return SelectFromListDialog(
        title: "感谢方式",
        btnTitle: "保存",
        dataList: thankTypeModels
            .map((e) => ListSheetModel(
                  title: e.mainLabel,
                  id: e.id.toString(),
                  isChoose: e.id == selectedThankTypeModel?.id,
                ))
            .toList(),
        onSubmit: (ListSheetModel model) {
          // debugPrint('ListSheetModel = ${model.id}');
          ThankTypeModel thankTypeModel =
              thankTypeModels.firstWhere((element) => element.id == model.id);
          chooseCompleteBlock(bThankTypeModel: thankTypeModel);
        },
        onInfoClick: () async {
          RulesBottomDialog.show(context, RuleType.thank);
        },
      );
    });
  }
}
