import 'package:flutter/material.dart';
import '../flutter_share_kit_adapt.dart';

class CommonShareWidget extends StatefulWidget {
  final Function(int) onClick;

  const CommonShareWidget({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  _CommonShareWidgetState createState() => _CommonShareWidgetState();
}

class _CommonShareWidgetState extends State<CommonShareWidget> {
  @override
  Widget build(BuildContext context) {
    Widget wechatCell = cellWidget(
      context,
      text: "微信",
      imageName: "assets/wechat_icon.png",
      onTap: () {
        widget.onClick(0);
      },
    );

    Widget friendCircleCell = cellWidget(
      context,
      text: "朋友圈",
      imageName: "assets/share_img1.png",
      onTap: () {
        // widget.onClick(0);
      },
    );

    Widget posterCell = cellWidget(
      context,
      text: "分享海报",
      imageName: "assets/share_img6.png",
      onTap: () {
        widget.onClick(1);
      },
    );

    Widget dingdingCell = cellWidget(
      context,
      text: "钉钉",
      imageName: "assets/share_img3.png",
      onTap: () {
        // widget.onClick(0);
      },
    );

    Widget sinaCell = cellWidget(
      context,
      text: "新浪微博",
      imageName: "assets/share_img4.png",
      onTap: () {
        // widget.onClick(0);
      },
    );

    Widget copyLinkCell = cellWidget(
      context,
      text: "复制链接",
      imageName: "assets/share_img5.png",
      onTap: () {
        // widget.onClick(0);
      },
    );

    Widget qqCell = cellWidget(
      context,
      text: "QQ",
      imageName: "assets/share_img2.png",
      onTap: () {
        // widget.onClick(0);
      },
    );

    Widget holderCell = cellWidget(
      context,
      text: "",
      imageName: "",
      onTap: () {
        // widget.onClick(0);
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32.w_cj),
          topLeft: Radius.circular(32.h_cj),
        ),
      ),
      height: 484.h_cj,
      child: Column(
        children: [
          Stack(
            children: [
              _titleWidget,
              Positioned(right: 0, child: _closeWidget),
            ],
          ),
          Row(
            children: [
              Expanded(child: wechatCell),
              Expanded(child: friendCircleCell),
              Expanded(child: posterCell),
              Expanded(child: dingdingCell),
            ],
          ),
          Row(
            children: [
              Expanded(child: sinaCell),
              Expanded(child: copyLinkCell),
              Expanded(child: qqCell),
              Expanded(child: holderCell),
            ],
          ),
        ],
      ),
    );
  }

  // 标题视图
  Widget get _titleWidget {
    return Container(
      padding: EdgeInsets.only(
        left: 30.w_cj,
        top: 36.h_cj,
        right: 30.w_cj,
        bottom: 30.h_cj,
      ),
      alignment: Alignment.center,
      // width: Adapt.screenW(),
      child: const Text(
        "分享",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 36,
          color: Color(0xff333333),
        ),
      ),
    );
  }

  // 关闭按钮视图
  Widget get _closeWidget {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 30.w_cj,
          top: 30.h_cj,
          right: 30.w_cj,
          bottom: 30.h_cj,
        ),
        child: Image.asset(
          "images/hope/close_icon2.png",
          width: 30.w_cj,
          color: const Color(0xff595959),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  // 分享item视图
  Widget cellWidget(
    BuildContext context, {
    required String text,
    required String imageName,
    required void Function() onTap,
  }) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Image.asset(
              imageName,
              width: 78.w_cj,
              fit: BoxFit.fitWidth,
              package: 'flutter_share_kit',
            ),
            Container(height: 14.h_cj),
            Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xff595959),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        padding: EdgeInsets.all(20.w_cj),
        color: Colors.transparent,
      ),
      onTap: onTap,
    );
  }
}
