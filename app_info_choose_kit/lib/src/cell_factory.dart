import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../app_info_choose_kit_adapt.dart';

class ImageTitleTextValueCell extends StatelessWidget {
  String title;
  ImageProvider imageProvider;
  String textValue;
  String textValuePlaceHodler;
  void Function() onTap;

  ImageTitleTextValueCell({
    Key key,
    this.title,
    this.imageProvider,
    this.textValue,
    this.textValuePlaceHodler,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleTextValueCell(
      height: 52.h_pt_cj,
      leftRightPadding: 0,
      title: title,
      imageProvider: imageProvider,
      imageWith: 22.w_pt_cj,
      imageTitleSpace: 10.w_pt_cj,
      textValue: textValue,
      textValuePlaceHodler: textValuePlaceHodler,
      textValuePlaceHodlerColor: const Color(0xFFC1C1C1),
      onTap: onTap,
    );
  }
}
