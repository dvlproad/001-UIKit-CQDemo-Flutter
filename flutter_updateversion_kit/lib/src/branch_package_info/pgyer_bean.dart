/*
 * @Author: dvlproad
 * @Date: 2022-12-21 15:35:41
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-12-21 17:06:23
 * @Description: 
 */
import 'dart:io' show Platform;
import 'dart:convert' show json; // 用于使用json.decode

class PgyerPlatformBean {
  String pygerAppKey;
  String appOfficialWebsite;

  PgyerPlatformBean({
    required this.pygerAppKey,
    required this.appOfficialWebsite,
  });

  static PgyerPlatformBean fromJson(Map<String, dynamic> json) {
    String pygerAppKey = json["pygerAppKey"] ?? '';

    String appOfficialWebsite = json["appOfficialWebsite"] ?? '';

    return PgyerPlatformBean(
      pygerAppKey: pygerAppKey,
      appOfficialWebsite: appOfficialWebsite,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (pygerAppKey != null) {
      data["pygerAppKey"] = this.pygerAppKey;
    }

    if (appOfficialWebsite != null) {
      data["appOfficialWebsite"] = this.appOfficialWebsite;
    }

    return data;
  }
}

class PgyerChannelConfigModel {
  final String? pgyerChannelShortcut_upload;
  final String? pgyerChannelKey_upload;
  final String? pgyerChannelShortcut_download;
  final String? pgyerChannelKey_download;

  PgyerChannelConfigModel({
    this.pgyerChannelShortcut_upload,
    this.pgyerChannelKey_upload,
    this.pgyerChannelShortcut_download,
    this.pgyerChannelKey_download,
  });

  static PgyerChannelConfigModel fromJson(Map<String, dynamic> json) {
    String? pgyerChannelShortcut_upload = json["uploadChannelShortcut"];
    String? pgyerChannelKey_upload = json["uploadChannelKey"];

    String? pgyerChannelShortcut_download = json["downloadChannelShortcut"];
    String? pgyerChannelKey_download = json["downloadChannelKey"];
    // 下载短链未设置时候，使用上传
    if (pgyerChannelShortcut_download == null) {
      pgyerChannelShortcut_download ??= pgyerChannelShortcut_upload;
      pgyerChannelKey_download ??= pgyerChannelKey_upload;
    }

    return PgyerChannelConfigModel(
      pgyerChannelShortcut_upload: pgyerChannelShortcut_upload,
      pgyerChannelKey_upload: pgyerChannelKey_upload,
      pgyerChannelShortcut_download: pgyerChannelShortcut_download,
      pgyerChannelKey_download: pgyerChannelKey_download,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (pgyerChannelShortcut_upload != null) {
      data["uploadChannelShortcut"] = this.pgyerChannelShortcut_upload;
    }

    if (pgyerChannelKey_upload != null) {
      data["uploadChannelKey"] = this.pgyerChannelKey_upload;
    }

    if (pgyerChannelShortcut_download != null) {
      data["downloadChannelShortcut"] = this.pgyerChannelShortcut_download;
    }

    if (pgyerChannelKey_upload != null) {
      data["downloadChannelKey"] = this.pgyerChannelKey_upload;
    }

    return data;
  }
}
