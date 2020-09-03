import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class CQDurationBadgeDelegate extends BadgeDelegate {
  final AlignmentGeometry alignment;
  const CQDurationBadgeDelegate({this.alignment = Alignment.bottomRight});

  @override
  Widget buildBadge(BuildContext context, AssetType type, Duration duration) {
    if (type == AssetType.video) {
      var s = duration.inSeconds % 60;
      var m = duration.inMinutes % 60;
      var h = duration.inHours;

      String text =
          "$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";

      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Align(
          alignment: alignment,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.65),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
            padding: const EdgeInsets.all(4.0),
          ),
        ),
      );
    }

    return Container();
  }
}

/// 相册选择的 checkbox
class CQImageCheckBox extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  const CQImageCheckBox({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget child;
    BoxDecoration decoration;

    if (text != null && text.isNotEmpty) {
      child = Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.0, color: Colors.black),
      );
      decoration = BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(width / 2),
      );
    } else {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(width / 2),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      );
    }

    return GestureDetector(
      onTap: this.onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: decoration,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
