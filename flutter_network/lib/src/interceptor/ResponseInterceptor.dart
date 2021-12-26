// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
// import 'package:toast/toast.dart';
// import 'package:wish/common/event_bus.dart';
// import 'package:wish/common/route_manager.dart';
// import 'package:wish/routes/app_routes.dart';
// import 'package:wish/ui/app.dart';
// import 'package:wish/ui/base/error_page.dart';
// import 'Loading.dart';
// import 'ResultData.dart';
import 'dart:convert' as convert;

/// 数据初步处理
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
    Loading.dismiss();

    //String errorMessage = err.message;
    String errorMessage = "非常抱歉！服务器开小差了～";
    Toast.show(errorMessage, navigatorKey.currentState.overlay.context,
        gravity: Toast.CENTER, duration: 2);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions option = response.requestOptions;
    // var datas =  response.data["data"];
    //
    // if(datas == null){
    //    response.data["data"] = [];
    // }
    //反序列化
    try {
      //_user_login()
      // if (option.contentType != null  && (response.data["tel"] != null || response.data["code"] != null  )) {
      //   if(response.statusCode == 200){
      //     response.data = ResultData(response.data, true, 200);
      //     handler.next(response);
      //   }else{
      //     response.data = ResultData(response.data, false, response.statusCode);
      //     handler.next(response);
      //   }
      //   return;
      // }

      Map<String, dynamic> map;
      if (response.data is Map) {
        //String dataString = response.data.toString();
        String dataJsonString = convert.jsonEncode(response.data);
        map = jsonDecode(dataJsonString);
      } else {
        map = jsonDecode(response.data);
      }

      ///一般只需要处理200的情况，300、400、500保留错误信息，外层为http协议定义的响应码
      if ((response.statusCode == 200 || response.statusCode == 201)) {
        ///内层需要根据公司实际返回结构解析，一般会有code，data，msg字段
        int code = map["code"];
        // if (code is String) {
        //
        // }
        String msg = map["msg"];
        msg == null ? msg = "抱歉！网络请求失败～" : null;
        // if (code == 500) {
        //   msg = "非常抱歉！服务器开小差了～";
        // }
        if (code == 0) {
          response.data = ResultData(map["data"], true, code, msg,
              headers: response.headers);
          handler.next(response);
        } else {
          Toast.show(msg, navigatorKey.currentState.overlay.context,
              gravity: Toast.CENTER, duration: 2);
          if (code == 500) {
            response.data =
                ResultData(map, false, code, msg, headers: response.headers);
            handler.next(response);
          }
        }
      }
    } catch (e) {
      print("ResponseError====" + e.toString() + "****" + option.path);
      response.data = ResultData(response.data, false, response.data["code"],
          response.data["msg"] ??= "抱歉！网络请求失败～",
          headers: response.headers);
      handler.next(response);
      // RouteManager.pushToRoute2(navigatorKey.currentState.overlay.context,ErrorPage());
    }
    // response.data = ResultData(response.data, response.statusCode == 200 ? true :false, response.statusCode, headers: response.headers);
    // handler.next(response);
  }
}
