/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 23:40:05
 * @Description: 语音模型
 */
class VoiceBaseBean {
  String? localPath; // 本地地址
  String? networkUrl; // 网络地址

  String? recorderTxt; // 语音长度显示的文本(如1秒，显示成00:01)
  int? timeInt; // 语音长度

  VoiceBaseBean({
    this.localPath,
    this.networkUrl,
    this.recorderTxt,
    this.timeInt,
  });
}
