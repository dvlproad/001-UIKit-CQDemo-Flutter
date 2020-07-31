import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:tsdemodemo_flutter/modules/user_bean.dart';

class AvatarWidget extends StatelessWidget {
  final UserBean userBean;
  final double radius;
  final double strokeWidth;
  final VoidCallback onTap;

  const AvatarWidget(
      {Key key,
      @required this.userBean,
      @required this.radius,
      this.strokeWidth = 1.5,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) {
//          Routes.navigateTo(context, Routes.infoPage, params: {"userID": userBean.id});
        } else {
          onTap.call();
        }
      },
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
            height: radius * 2,
            width: radius * 2,
            child: CustomPaint(
              painter: AvatarCirclePainter(
                  strokeWidth: strokeWidth, colors: grade()),
            )),
        if (userBean != null && userBean.avatar != null)
          CircleAvatar(
            radius: radius - strokeWidth * 2,
            backgroundImage: CachedNetworkImageProvider(userBean.avatar ?? ""),
          )
      ]),
    );
  }

  List<Color> grade() {
    if (this.userBean == null || this.userBean.grade == null) {
      return [
        Color(0xFFD8D8D8),
        Color(0xFF323232),
      ];
    }

    if (this.userBean.grade == 1) {
      return [
        Color(0xFFD8D8D8),
        Color(0xFF323232),
      ];
    }
    if (this.userBean.grade == 2) {
      return [
        Color(0xFF1FFD92),
        Color(0xFF1F5DFD),
      ];
    }
    if (this.userBean.grade == 3) {
      return [
        Color(0xFFFDFF00),
        Color(0xFFF99500),
      ];
    }
    return [
      Color(0xFFFF007A),
      Color(0xFFDA1E1E),
    ];
  }
}

class AvatarCirclePainter extends CustomPainter {
  final double strokeWidth;
  final List<Color> colors;

  AvatarCirclePainter({this.strokeWidth = 6, this.colors});

  @override
  paint(Canvas canvas, Size size) {
    final Offset offsetCenter = Offset(size.width / 2, size.width / 2);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(0, size.height),
        colors ??
            [
              Color(0xFFFF997A),
              Color(0xFFDA1E1E),
            ],
      )
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(
        offsetCenter, size.width / 2 - strokeWidth / 2, ringPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
