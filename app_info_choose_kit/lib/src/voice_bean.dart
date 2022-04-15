/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 19:15:17
 * @Description: 语音模型
 */
class VoiceBean {
  String localPath; // 本地地址
  String networkUrl; // 网络地址

  String recorderTxt; // 语音长度显示的文本(如1秒，显示成00:01)
  int timeInt; // 语音长度

  VoiceBean({
    this.localPath,
    this.networkUrl,
    this.recorderTxt,
    this.timeInt,
  });

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
