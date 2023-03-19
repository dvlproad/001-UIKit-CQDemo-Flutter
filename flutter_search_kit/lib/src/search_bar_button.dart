/*
 * @Author: dvlproad
 * @Date: 2022-12-19 11:27:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-05 11:48:45
 * @Description: 
 */
import 'package:flutter/material.dart';
import '../flutter_search_kit_adapt.dart';

enum SearchIconColorType {
  origin,
  grey,
  white,
}

class SearchIcon extends StatelessWidget {
  final double? size;
  final double? badeSize;
  final SearchIconColorType iconColorType;

  const SearchIcon({
    Key? key,
    this.size,
    this.badeSize, // 视图与icon之间的左右间距
    this.iconColorType = SearchIconColorType.origin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? iconColor;
    if (iconColorType == SearchIconColorType.grey) {
      iconColor = const Color(0xff8b8b8b);
    } else if (iconColorType == SearchIconColorType.white) {
      iconColor = Colors.white;
    }

    double width = size ?? 16.w_pt_cj;
    double iconWidth = width;
    if (badeSize != null) {
      iconWidth = width - 2 * badeSize!;
    }

    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/search_black2.png",
        package: 'flutter_search_kit',
        width: iconWidth,
        height: iconWidth,
        // fit: BoxFit.fitWidth,
        fit: BoxFit.contain,
        color: iconColor,
      ),
    );
  }
}

class SearchBarButton extends StatelessWidget {
  double? height;
  double searchIconWidth;

  double? leftRightMargin;
  String? placeholder;
  GestureTapCallback? onTap;

  final SearchIconColorType iconColorType;

  SearchBarButton({
    Key? key,
    this.height,
    this.searchIconWidth = 16,
    this.leftRightMargin,
    this.placeholder,
    this.iconColorType = SearchIconColorType.origin,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          left: 15.w_pt_cj,
          right: 15.w_pt_cj,
        ),
        height: height,
        decoration: BoxDecoration(
          color: Color(0xfff0f0f0),
          borderRadius: BorderRadius.all(Radius.circular(4.w_pt_cj)),
        ),
        child: _searchBar(
          context,
          searchIconWidth: searchIconWidth,
        ),
      ),
    );

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
            SearchIcon(size: 18.w_pt_cj),
            SizedBox(width: 6.w_pt_cj),
            Text(
              placeholder ?? '搜索',
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

  Widget _searchBar(
    BuildContext context, {
    double searchIconWidth = 16,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 16.w_pt_cj,
          padding: EdgeInsets.only(
            left: 10.w_pt_cj,
            right: 5.w_pt_cj,
          ),
          child: SearchIcon(
            size: searchIconWidth,
            iconColorType: this.iconColorType,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 33.h_pt_cj,
            child: Text(
              "搜索",
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
                color: const Color(0xffB8B8B8),
                // height: 1,
                fontSize: 15.w_pt_cj,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
