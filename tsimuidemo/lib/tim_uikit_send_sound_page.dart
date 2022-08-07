/*
 * @Author: dvlproad
 * @Date: 2022-04-23 23:56:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-25 13:53:52
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsimuidemo/tim_uikit_send_sound_message.dart';

class SendSoundPage extends StatefulWidget {
  SendSoundPage({Key? key}) : super(key: key);

  @override
  State<SendSoundPage> createState() => _SendSoundPageState();
}

class _SendSoundPageState extends State<SendSoundPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 100, color: Colors.red),
          SendSoundMessage(
            conversationID: "",
            conversationType: 1,
            onDownBottom: () {
              print('object');
            },
          ),
        ],
      ),
    );
  }
}
