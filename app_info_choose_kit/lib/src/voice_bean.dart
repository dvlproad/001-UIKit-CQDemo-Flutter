/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-07 19:03:33
 * @Description: 语音模型
 */
import "package:flutter_image_process/flutter_image_process.dart";

class VoiceBean extends VoiceBaseBean {
  VoiceBean({
    String localPath,
    String networkUrl,
    String recorderTxt,
    int timeInt,
  }) : super(
          localPath: localPath,
          networkUrl: networkUrl,
          recorderTxt: recorderTxt,
          timeInt: timeInt,
        );

  VoiceBean.fromJson(Map<String, dynamic> json) {
    localPath = json["localPath"];
    networkUrl = json["networkUrl"];
    recorderTxt = json["recorderTxt"];
    timeInt = json["timeInt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["localPath"] = localPath;
    data["networkUrl"] = networkUrl;
    data["recorderTxt"] = recorderTxt;
    data["timeInt"] = timeInt;

    return data;
  }
}
