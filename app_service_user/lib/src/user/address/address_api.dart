/*
 * @Author: dvlproad
 * @Date: 2022-03-01 11:49:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:40:48
 * @Description: 地址相关api
 */
// import 'package:wish/http/Network/UrlPath.dart';
import 'package:app_devtool_framework/app_devtool_framework.dart';
import 'package:app_service_user/app_service_user.dart';
import './address_list_entity.dart';

class AddressApi {
  static Future<bool> getAddressList() {
    return AppNetworkKit.post(
      'UrlPath.address_list',
    ).then((ResponseModel responseModel) {
      /*
      List<AddressListEntity> addressModels = [];
      if (responseModel.isSuccess) {
        List addressMaps = responseModel.result;
        for (var element in addressMaps) {
          AddressListEntity addressModel =
              AddressListEntity().fromJson(element);
          addressModels.add(addressModel);
        }
        UserInfoManager().userModel.addressModels = addressModels;
        if (addressModels.isNotEmpty) {
          UserInfoManager().userModel.defaultAddressModel = addressModels[0];
        } else {
          UserInfoManager().userModel.defaultAddressModel = null;
        }
        return true;
      } else {
        return false;
      }
      */
    });
  }
}
