/*
 * @Author: dvlproad
 * @Date: 2022-07-07 18:51:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-10 23:32:37
 * @Description: 
 */
import 'dart:io' show Platform;
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';

import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import './version_pyger_bean.dart';

import './pgyer_env_util.dart';
import './pgyer_env_util.dart' show PgyerAppType;

import './pgyer_network_manager.dart';

class PygerUtil {
  static late String _pgyerDownloadUrl; // 应用在蒲公英上的下载网页(当检查更新的接口未返回网页时候，需要使用)

  static void init({required UpdateAppType pgyerAppType}) async {
    PgyerAppBean packageBean = PgyerEnvUtil.diffPackageBeanByType(pgyerAppType);

    String pygerApiKey = packageBean.pygerApiKey;
    String pygerAppKey;
    if (Platform.isAndroid) {
      pygerAppKey = packageBean.pygerAppKeyAndroid;
    } else {
      pygerAppKey = packageBean.pygerAppKeyIOS;
    }

    String platformName = "";
    if (Platform.isIOS) {
      platformName = 'ios';
    } else if (Platform.isAndroid) {
      platformName = 'android';
    }
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    Map<String, dynamic> bodyCommonFixParams = {
      "_api_key": pygerApiKey,
      "appKey": pygerAppKey,
      "buildVersion": appVersion,
      "buildBuildVersion": buildBuildVersion,
    };

    PgyerNetworkManager().normal_start(
      baseUrl: "https://www.pgyer.com/",
      headerCommonFixParams: {},
      bodyCommonFixParams: bodyCommonFixParams,
    );

    _pgyerDownloadUrl = packageBean.downloadUrl;
  }

  // 之前对升级弹窗点击取消，后续不再弹出的那些版本号
  static void cancelShowVersion<T extends VersionBaseBean>(T bean) async {
    CheckVersionCommonUtil.addCancelShowVersion(bean.version, bean.buildNumber);
  }

  ///版本检查:蒲公英
  static Future<ResponseModel> getVersion() async {
    String url = 'https://www.pgyer.com/apiv2/app/check';

    ResponseModel responseModel = await PgyerNetworkManager().requestUrl(
      url,
      requestMethod: RequestMethod.post,
    );
    if (responseModel.isSuccess != true) {
      return responseModel;
    }

    Map<String, dynamic> result = responseModel.result;
    VersionPgyerBean bean = VersionPgyerBean.fromJson(result);
    // if (bean.downloadUrl.startsWith(RegExp(r'https?:')) != true) {
    if(Platform.isIOS){
      bean.downloadUrl = _pgyerDownloadUrl;
    }
    // TODO:在安卓机上发现使用蒲公英的下载地址。如果没有授权“始终”以默认浏览器打开，就会出现那个“下载超时”，若是有始终授权的话，直接跳转到默认浏览器下载页进行下载
    // 所以暂时都用外部地址
    // }
    responseModel.result = bean;

    return responseModel;
  }

  ///获取App所有版本:蒲公英
  static Future<ResponseModel> getPgyerHistoryVersions() async {
    String url = 'https://www.pgyer.com/apiv2/app/builds';

    ResponseModel responseModel = await PgyerNetworkManager().requestUrl(
      url,
      requestMethod: RequestMethod.post,
      customParams: {
        "buildKey": 'com.bojue.wish',
        "page": 3, //(选填) 历史版本分页页数
      },
    );

    return responseModel;
  }
}
