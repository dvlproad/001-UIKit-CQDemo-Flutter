import 'package:flutter/material.dart';
import 'package:wish/tool/sound_dialog_view_new.dart';

import '../app_info_choose_kit_adapt.dart';
import './base_tag_widget.dart';
import './voice_util.dart';

class VoiceChoooseTagWidget extends StatefulWidget {
  final VoiceBean voiceBean;
  final void Function(VoiceBean bVoiceBean) valueChangeBlock;

  VoiceChoooseTagWidget({
    Key key,
    @required this.voiceBean,
    @required this.valueChangeBlock,
  }) : super(key: key);

  @override
  State<VoiceChoooseTagWidget> createState() => _VoiceChoooseViewState();
}

class _VoiceChoooseViewState extends State<VoiceChoooseTagWidget> {
  VoiceBean _voiceBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _isPlay = false;
  }

  Widget _createSoundWave(BuildContext context) {
    return Image.asset(
      "assets/icon_voice_yinbo.png",
      package: 'app_info_choose_kit',
      height: 15.w_pt_cj,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    _voiceBean = widget.voiceBean;

    bool hasContent = _voiceBean != null;
    String buttonText = '语音';
    String buttonImageName = "assets/icon_voice_record.png";
    if (hasContent) {
      buttonImageName = _isPlay
          ? "assets/icon_pause_theme.png"
          : "assets/icon_play_theme.png";
    }

    return BaseTagWidget(
      backgroundColor: Color(0xFFFF7F00).withOpacity(0.3),
      buttonText: buttonText,
      buttonImageProvider: AssetImage(
        buttonImageName,
        package: 'app_info_choose_kit',
      ),
      contentWidgetWhenShowDelete: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createSoundWave(context),
          Container(width: 5),
          _createSoundWave(context),
          Container(width: 10),
          Text(
            '${_voiceBean.timeInt}"',
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
              height: 1,
            ),
          ),
        ],
      ),
      onTap: () {
        if (hasContent == false) {
          _addVoice(context);
        } else {
          if (_isPlay) {
            Singleton.instance.stopPlayer().then((value) {
              _isPlay = false;
              setState(() {});
            });
          } else {
            String voicePath = _voiceBean.localPath;
            if (voicePath == null) {
              voicePath = _voiceBean.networkUrl;
            }
            Singleton.instance.startPlayer(voicePath, (isPlayEnd) {
              _isPlay = isPlayEnd;
              setState(() {});
            });
          }
        }
      },
      showDeleteIcon: !hasContent ? false : true,
      customDeleteIconBuilder: () {
        return Image.asset(
          "assets/icon_delete_voice.png",
          package: 'app_info_choose_kit',
          width: 16.w_pt_cj,
          height: 16.h_pt_cj,
          fit: BoxFit.cover,
        );
      },
      onTapDelete: () {
        _clearVoice(context);
      },
    );
  }

  void _addVoice(BuildContext context) {
    VoiceUtil.addVoice(
      context,
      valueChangeBlock: (VoiceBean bVoiceBean) {
        _voiceBean = bVoiceBean;
        if (widget.valueChangeBlock != null) {
          widget.valueChangeBlock(_voiceBean);
        }

        setState(() {});
      },
    );
  }

  void _clearVoice(BuildContext context) {
    VoiceUtil.clearVoice(
      context,
      valueChangeBlock: (VoiceBean bVoiceBean) {
        _voiceBean = bVoiceBean;
        if (widget.valueChangeBlock != null) {
          widget.valueChangeBlock(_voiceBean);
        }

        setState(() {});
      },
    );
  }
}
