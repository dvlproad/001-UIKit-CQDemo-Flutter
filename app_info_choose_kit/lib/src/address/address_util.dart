/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-28 20:13:07
 * @Description: 收货地址工具类
 */
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import 'package:wish/service/user/address/address_list_entity.dart';
export 'package:wish/service/user/address/address_list_entity.dart'
    show AddressListEntity;

import 'package:wish/ui/class/mine/mine_set_page.dart';

class AddressUtil {
  // 进入选择地址界面
  static goChooseAddressPage(
    BuildContext context, {
    AddressListEntity selectedAddressModel,
    @required Function({AddressListEntity bAddressModel}) chooseCompleteBlock,
  }) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MineSetPage(
          isSelect: true,
          selectedAddressModel: selectedAddressModel,
          callBack: (data) {
            if (chooseCompleteBlock != null) {
              chooseCompleteBlock(bAddressModel: data);
            }
          });
    }));
  }
}
