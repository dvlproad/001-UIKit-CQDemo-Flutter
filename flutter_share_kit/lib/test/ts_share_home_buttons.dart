/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-13 17:58:43
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_share_kit/flutter_share_kit_adapt.dart';

class TSShareHomeButtons extends StatelessWidget {
  final void Function() saveHandle;
  final String button2Text;

  final void Function() button2Handle;
  const TSShareHomeButtons({
    Key? key,
    required this.saveHandle,
    required this.button2Text,
    required this.button2Handle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaData = MediaQuery.of(context);
    double screenWidth = mediaData.size.width;
    // double screenHeight = mediaData.size.height;
    // double screenPaddingTop = mediaData.padding.top;
    double screenPaddingBottom = mediaData.padding.bottom;

    return Positioned(
      bottom: screenPaddingBottom + 100.h_pt_cj,
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.only(left: 26.w_pt_cj, right: 26.w_pt_cj),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shareButton(context),
            _savePosterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _shareButton(BuildContext context) {
    return TextButton(
      onPressed: saveHandle,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(22.h_pt_cj),
        ),
        width: 140.w_pt_cj,
        height: 44.h_pt_cj,
        alignment: Alignment.center,
        child: const Text(
          "分享XXX",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  Widget _savePosterButton(BuildContext context) {
    return TextButton(
      onPressed: button2Handle,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(22.h_pt_cj),
        ),
        width: 140.w_pt_cj,
        height: 44.h_pt_cj,
        alignment: Alignment.center,
        child: Text(
          button2Text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
