import 'package:flutter/material.dart';
import '../flutter_search_kit_adapt.dart';

class SearchBarButton extends StatelessWidget {
  double height;
  double leftRightMargin;
  String placeholder;
  GestureTapCallback onTap;

  SearchBarButton({
    Key key,
    this.height,
    this.leftRightMargin,
    this.placeholder,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: this.height ?? 40.h_pt_cj,
        margin: EdgeInsets.only(
          left: this.leftRightMargin ?? 15.w_pt_cj,
          right: this.leftRightMargin ?? 15.w_pt_cj,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/search_black.png",
              package: 'flutter_search_kit',
              width: 18.w_pt_cj,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(width: 6.w_pt_cj),
            Text(
              placeholder,
              style: TextStyle(
                fontSize: 15.w_pt_cj,
                fontWeight: FontWeight.w400,
                color: Color(0xFF484848),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
