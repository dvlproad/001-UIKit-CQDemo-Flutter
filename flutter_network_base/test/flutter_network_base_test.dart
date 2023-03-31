/*
 * @Author: dvlproad
 * @Date: 2023-03-23 18:27:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-31 11:47:52
 * @Description: 
 */
import 'package:flutter_test/flutter_test.dart';

import 'package:dio/dio.dart';
// import 'package:flutter_network_base/flutter_network_base.dart';

void main() {
  test('adds one to input values', () async {
    // String url = "/order/getOrderListPage";

    Dio testDio = Dio();
    String baseUrl = "http://test.api.xxx.com/hapi";

    String headerAuthorization =
        "bearer clientApp733016f9-8dc5-436a-9e97-f1046bf29e95";

    Map<String, dynamic> headers = {};
    // headers.addAll(headerCommonFixParams);
    // if (headerCommonChangeParamsGetBlock != null) {
    //   headers.addAll(headerCommonChangeParamsGetBlock());
    // }
    if (headerAuthorization.isNotEmpty) {
      headers.addAll({'Authorization': headerAuthorization});
    }

    testDio.options = testDio.options.copyWith(
      baseUrl: baseUrl,
      // connectTimeout: connectTimeout,
      // receiveTimeout: receiveTimeout,
      // contentType: contentType,
      headers: headers,
    );
    /*
    Response testResponse = await testDio.post(
      url,
      data: customParams,
      options: options ??
          Options(
            receiveTimeout: dio.options.receiveTimeout,
            contentType: dio.options.contentType,
            headers: dio.options.headers,
          ),
      cancelToken: cancelToken,
    );
    List realItemArray = testResponse.data["data"]["orderPayInfoList"];
    debugPrint("数据个数应该为:${realItemArray.length.toString()}");

    List itemArray = response.data["data"]["orderPayInfoList"];
    debugPrint("数据个数现在为:${itemArray.length.toString()}");
    */
  });
}
