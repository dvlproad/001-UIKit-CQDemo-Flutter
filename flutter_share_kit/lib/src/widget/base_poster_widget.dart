/*
 * @Author: dvlproad
 * @Date: 2024-02-28 17:34:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-07 15:31:17
 * @Description: 
 */

import 'package:flutter/material.dart';

class NormalPosterWidget extends StatelessWidget {
  final Widget Function(BuildContext context) posterWidgetGetBlock;

  final GlobalKey posterRepaintBoundaryGlobalKey;
  final Widget Function(BuildContext context) noposterWidgetGetBlock;

  const NormalPosterWidget({
    Key? key,
    required this.posterWidgetGetBlock,
    required this.posterRepaintBoundaryGlobalKey,
    required this.noposterWidgetGetBlock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          RepaintBoundary(
            key: posterRepaintBoundaryGlobalKey,
            child: posterWidgetGetBlock(context),
          ),
          noposterWidgetGetBlock(context),
        ],
      ),
    );
  }
}
