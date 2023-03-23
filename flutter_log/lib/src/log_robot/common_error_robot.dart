/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 19:03:28
 * @Description: 底层企业微信机器人
 */
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart';
// import 'package:package_info/package_info.dart';

import 'package:flutter/foundation.dart';
import '../string_format_util/formatter_object_util.dart';

enum RobotPostType {
  text,
  markdown,
  file,
}

class CommonErrorRobot {
  static String get myRobotKey => _tolerantRobotKey; // 单个人测试用的

  static late String _tolerantRobotKey;
  static late String _packageDescribe; // 包的描述(生产、测试、开发包)
  static String Function()? _userDescribeBlock; // 当前使用该包的用户信息
  static void init({
    required String tolerantRobotKey, // 为防止找不到机器人时候上报信息丢失，而添加的容错机器人
    String? packageDescribe, // 包的描述(生产、测试、开发包)
    String Function()? userDescribeBlock, // 当前使用该包的用户信息
  }) {
    _tolerantRobotKey = tolerantRobotKey;
    _packageDescribe = packageDescribe ?? "未知包"; // 包、平台、分支及版本等相关信息
    _userDescribeBlock = userDescribeBlock;
  }

  /// 通用异常上报:企业微信
  static Future<bool> posts({
    List<String>? robotUrls,
    RobotPostType postType = RobotPostType.text,
    List<String>? mentionedList,
    String? title,
    required String customMessage,
  }) async {
    if (robotUrls == null || robotUrls.isEmpty) {
      String myRobotKey = CommonErrorRobot.myRobotKey; // 单个人测试用的
      robotUrls = [myRobotKey];
    }

    bool isPostSuccess = true;
    for (String robotKey in robotUrls) {
      if (robotKey.isEmpty) {
        continue;
      }
      isPostSuccess = await post(
        robotKey: robotKey,
        postType: postType,
        title: title,
        customMessage: customMessage,
        mentionedList: mentionedList,
      );
    }

    return isPostSuccess;
  }

  static Future<bool> post({
    String? robotKey,
    RobotPostType postType = RobotPostType.text,
    String? title, // 只是为了对 customMessage 起一个强调作用。(一般此title肯定在customMessage有包含到)
    required String customMessage,
    List<String>? mentionedList,
  }) async {
    robotKey ??= _tolerantRobotKey; // 单个人测试用的

    String fullMessage = '';
    // 标题 title（可为null，不是null时候，只是为了对错误内容 customMessage 起强调中庸）
    if (title != null && title.isNotEmpty) {
      fullMessage += '$title\n';
    }

    fullMessage += _packageDescribe;

    if (_userDescribeBlock != null) {
      String userDescribe = _userDescribeBlock!(); // 当前使用该包的用户信息
      fullMessage += '\n$userDescribe';
    }

    // 错误内容 customMessage
    fullMessage += '\n$customMessage';

    Map<String, dynamic> customParams;
    if (postType == RobotPostType.markdown) {
      String content = fullMessage;
      // String content = testMarkdownContent_json;

      customParams = {
        "msgtype": "markdown", // 消息类型，此时固定为 markdown
        "markdown": {
          "content": content, // markdown内容，最长不超过4096个字节，必须是utf8编码
          "mentioned_list": mentionedList ?? [],
          // "mentioned_mobile_list": buildBuildVersion,
        },
      };
    } else if (postType == RobotPostType.file) {
      String? mediaId = await uploadFileByString(
        robotKey: robotKey,
        fileString: fullMessage,
        fileName: title ?? '未传fileName',
      );
      if (mediaId == null) {
        return false;
      }
      String content = testMarkdownContent_json;
      customParams = {
        "msgtype": "file", // 消息类型，此时固定为file
        "file": {
          "media_id": mediaId, // 文件id，通过文件上传接口获取
        },
      };
    } else {
      // text 方式
      String content = fullMessage;
      customParams = {
        "msgtype": "text", // 消息类型，此时固定为 text
        "text": {
          "content": content, // 文本内容，最长不超过2048个字节，必须是utf8编码
          "mentioned_list": mentionedList ?? [],
          // "mentioned_mobile_list": buildBuildVersion,
        },
      };
    }

    Options options = Options(
      contentType: "application/json",
    );

    CancelToken cancelToken = CancelToken();

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=$robotKey",
        data: customParams,
        options: options,
        cancelToken: cancelToken,
      );

      Map responseObject = response.data;
      if (responseObject['errcode'] != 0) {
        String errorMessage = responseObject['errmsg'];
        print('企业微信请求失败:errorMessage=$errorMessage');
        return false;
      }

      return true;
    } catch (err) {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  static get testMarkdownContent_normal {
    return '''实时新增用户反馈<font color=\"warning\">132例</font>，请相关同事注意。
            类型:<font color=\"comment\">用户反馈</font>
            普通用户反馈:<font color=\"comment\">117例</font>
            VIP用户反馈:<font color=\"comment\">15例</font>
            [Joker''s Blog](https: // blog.csdn.net/huanglin6)
            ```
            aaa
            bbb
            ```
            ''';
  }

  // ignore: non_constant_identifier_names
  static get testMarkdownContent_json {
    Map jsonMap = {
      "code": 0,
      "msg": "成功",
      "data": {
        "id": "1496888878978453504",
        "buyerId": "1475332557208702976",
        "state": 3,
        "statusUpdateTime": 1645721094257,
        "userType": "",
        "sortType": 1,
        "progress": {
          "wishId": "1496888878978453504",
          "rate": "34",
          "totalFee": 44505,
          "totalFeeStr": "445.05",
          "helpFee": 2,
          "helpFeeStr": "0.02",
          "goodsNum": 3,
          "helpGoodsNum": 1,
          "helpItems": [
            {
              "accountId": "1475311792488861696",
              "userName": "测试",
              "avatar":
                  "https://thirdwx.qlogo.cn/mmopen/vi_32/Sg04tg4rs4MXqZ4oRXZYO0M2oWjBAiaHmsF0gupEwL8cwMVkxXMIW9jfibeP4sdRthb90cI7aty0LmpO7UNVjDfA/132",
              "helpFee": 2,
              "helpFeeStr": "0.02",
              "helpGoodsNum": 1,
              "goodsList": [
                {
                  "goodsId": "1501909871522369536",
                  "skuId": "1501909872537391104",
                  "mainImgUrl":
                      "http://image.xxx.com/mcms/uploads/1646918150678361.jpg",
                  "amount": 2,
                  "amountStr": "0.02",
                  "goodsNum": 1
                }
              ]
            }
          ]
        },
      },
    };

    // String jsonString = json.encode(jsonMap);
    String jsonString = FormatterUtil.convert(jsonMap, 0);

    return '''实时新增用户反馈<font color=\"warning\">132例</font>，请相关同事注意。
            类型:<font color=\"comment\">用户反馈</font>
            普通用户反馈:<font color=\"comment\">117例</font>
            VIP用户反馈:<font color=\"comment\">15例</font>
            [dvlproad''s Blog](https://dvlproad.github.io/)
            ```
            ${jsonString}
            ```
            ''';
  }

  /// 通用异常上报:企业微信
  static Future<String?> uploadFileByString({
    String? robotKey,
    required String fileString,
    required String fileName,
  }) async {
    robotKey ??= _tolerantRobotKey; // 单个人测试用的

    MultipartFile multipartFile = await MultipartFile.fromString(
      fileString,
      filename: "$fileName.txt",
    );
    FormData formData = FormData.fromMap({
      "file": multipartFile,
    }); //form data上传文件
    Dio dio = new Dio();
    CancelToken cancelToken = CancelToken();
    Response response = await dio.post(
      'https://qyapi.weixin.qq.com/cgi-bin/webhook/upload_media?key=$robotKey&type=file',
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: (int count, int data) {
        // progressCallback(count, data, cancelToken);
      },
    );

    Map responseObject = response.data;
    if (responseObject['errcode'] != 0) {
      String errorMessage = responseObject['errmsg'];
      debugPrint('企业微信文件上传请求失败:errorMessage=$errorMessage');
      return null;
    }

    String mediaId = responseObject["media_id"];
    return mediaId;
  }
}
