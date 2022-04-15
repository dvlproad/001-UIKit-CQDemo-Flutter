class MockAnalyUtil {
  /// 判断是否是 mock 环境
  static bool isMockEnvironment(String url) {
    bool isMockEnvironment = url.startsWith('http://121.41.91.92:3000/mock/');
    return isMockEnvironment;
  }

  /// 获取 mock 环境下的 responseMap
  static Map<String, dynamic> responseMapFromMock(
    dynamic responseObject,
    String url,
  ) {
    Map<String, dynamic> responseMap = Map();

    if (responseObject is Map) {
      //print('responseObject.keys=${responseObject.keys}');
      bool mockHappenError =
          responseObject.keys.contains('errcode') == true; // mock环境是否发生错误
      if (mockHappenError == true) {
        responseMap['code'] = responseObject["errcode"];
        responseMap['msg'] = responseObject["errmsg"];
        responseMap["data"] = responseObject["data"];
      } else {
        if (responseObject.keys.contains('code') == false) {
          // 请求成功，但是模拟的环境，忘了在外层套上 code msg result，来使得和正常项目的结构一致，我们兼容这种返回
          responseMap['code'] = 0;
          responseMap['msg'] = '请求成功';
          responseMap["data"] = responseObject;
        } else {
          if (url.startsWith('http://121.41.91.92:3000/mock/3/api/beyond/')) {
            responseMap['code'] = responseObject["code"];
            responseMap['msg'] = responseObject["msg"];
            responseMap["data"] = responseObject["result"];
          } else {
            responseMap['code'] = responseObject["code"];
            responseMap['msg'] = responseObject["msg"];
            responseMap["data"] = responseObject["data"];
          }
        }
      }
    } else {
      // 为 List数组 或者 其他int基础类型
      responseMap['code'] = 0;
      responseMap['msg'] = '请求成功';
      responseMap["data"] = responseObject;
    }

    return responseMap;
  }
}
