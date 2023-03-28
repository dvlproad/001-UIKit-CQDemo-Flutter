// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2023-01-16 10:51:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 10:53:46
 * @Description: 
 */
import 'dart:convert';

class H5CallBridgeModel {
  String actionDes;
  String actionName;
  dynamic sendMessage;
  dynamic bridgeDescription;
  dynamic appCallbackDemo_ValueAndDescription;

  H5CallBridgeModel({
    required this.actionDes,
    required this.actionName,
    this.sendMessage,
    this.bridgeDescription,
    this.appCallbackDemo_ValueAndDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'h5CallBridgeActionDes': actionDes,
      'h5CallBridgeActionName': actionName,
      'h5CallBridgeSendMessage': sendMessage,
      "h5CallBridgeDescription": bridgeDescription,
      "appCallbackDemo_ValueAndDescription":
          appCallbackDemo_ValueAndDescription,
    };
  }

  factory H5CallBridgeModel.fromMap(Map<String, dynamic> map) {
    return H5CallBridgeModel(
      actionDes: map['h5CallBridgeActionDes'] ?? '',
      actionName: map['h5CallBridgeActionName'] ?? '',
      sendMessage: map['h5CallBridgeSendMessage'],
      bridgeDescription: map['h5CallBridgeDescription'],
      appCallbackDemo_ValueAndDescription:
          map['appCallbackDemo_ValueAndDescription'],
    );
  }

  String toJson() => json.encode(toMap());

  factory H5CallBridgeModel.fromJson(String source) =>
      H5CallBridgeModel.fromMap(json.decode(source));

  String get description {
    String _description = '';

    _description += actionName;

    _description += "\n";

    _description += "$sendMessage";

    return _description;
  }
}
