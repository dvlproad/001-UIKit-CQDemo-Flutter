import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:wish/tool/sound_dialog_view_new.dart';

import '../app_info_choose_kit_adapt.dart';
import './cell_factory.dart';
import './voice_util.dart';

import './voice_choose_tag_widget.dart';

class VoiceChoooseCellWidget extends StatefulWidget {
  final double leftRightPadding;
  final VoiceBean voiceBean;
  final void Function(VoiceBean bVoiceBean) valueChangeBlock;
  final bool showIconExistContent;

  VoiceChoooseCellWidget({
    Key key,
    this.leftRightPadding,
    @required this.voiceBean,
    @required this.valueChangeBlock,
    this.showIconExistContent = true,
  }) : super(key: key);

  @override
  State<VoiceChoooseCellWidget> createState() => _VoiceChoooseCellWidgetState();
}

class _VoiceChoooseCellWidgetState extends State<VoiceChoooseCellWidget> {
  VoiceBean _voiceBean;
  bool _isPlay;

  @override
  void initState() {
    super.initState();

    _voiceBean = widget.voiceBean;
    _isPlay = false;
  }

  @override
  Widget build(BuildContext context) {
    bool hasContent = _voiceBean != null;

    return ImageTitleCommonValueWithHolderTableViewCell(
      leftRightPadding: widget.leftRightPadding,
      height: 52.h_pt_cj,
      title: "语音",
      imageProvider: AssetImage(
        "assets/icon_voice_record.png",
        package: 'app_info_choose_kit',
      ),
      valueWidgetBuilder: (BuildContext bContext, {bool canExpanded}) {
        if (hasContent == false) {
          return null;
        }
        // 包一层Row，防止被里面的视图被拉伸
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VoiceChoooseTagWidget(
              showIconExistContent: widget.showIconExistContent,
              voiceBean: _voiceBean,
              valueChangeBlock: (bVoiceBean) {
                _voiceBean = bVoiceBean;
                if (widget.valueChangeBlock != null) {
                  widget.valueChangeBlock(_voiceBean);
                }

                // setState(() {});
              },
            )
          ],
        );
      },
      valuePlaceHodler: '点击录制',
      onTapCell: ({int section, int row}) async {
        bool hasContent = _voiceBean != null;
        if (hasContent) {
          return;
        }
        await VoiceUtil.addVoice(
          context,
          valueChangeBlock: (bVoiceBean) {
            _voiceBean = bVoiceBean;
            if (widget.valueChangeBlock != null) {
              widget.valueChangeBlock(_voiceBean);
            }

            setState(() {});
          },
        );
        print("add Voice");
      },
      arrowImageType: _voiceBean != null
          ? TableViewCellArrowImageType.none
          : TableViewCellArrowImageType.arrowRight,
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
