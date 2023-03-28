/*
 * @Author: dvlproad
 * @Date: 2022-07-01 10:17:40
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 13:48:42
 * @Description: 头像视图
 */
import 'package:flutter/material.dart';
import 'package:flutter_image_kit/flutter_image_kit.dart';
// import 'package:wish/route/route_manager.dart';
import '../user/user_base_bean.dart';

///携带皇冠的头像
class UserAavtarCrownWidget<T extends UserBaseBean> extends StatelessWidget {
  final T userBean;
  final double outerCircleSize; // 外框直径
  final double outerCircleWidth; // 外框与内框间距(一般为0，即看起来只有一个框)
  final bool disableGoPersonalPage;
  final Function onTap;
  const UserAavtarCrownWidget({
    Key? key,
    required this.outerCircleSize,
    this.outerCircleWidth = 0.0,
    required this.userBean,
    this.disableGoPersonalPage = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padding = outerCircleSize / 9;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        if (userBean != null && (userBean.consumerLevel ?? 0) > 0)
          LevelImage(
            level: userBean.consumerLevel,
            avtarSize: outerCircleSize,
            scale: 2.54,
          ),
        Padding(
            padding: EdgeInsets.only(
              top: padding,
              right: padding,
            ),
            child: UserAavtarWidget(
              outerCircleSize: outerCircleSize,
              outerCircleWidth: outerCircleWidth,
              disableGoPersonalPage: disableGoPersonalPage,
              userBean: userBean,
              onTap: onTap,
            )),
      ],
    );
  }
}

class LevelImage extends StatelessWidget {
  final int level;
  final double avtarSize;
  final double scale;

  LevelImage({
    Key? key,
    this.level,
    this.avtarSize,
    required this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _levelTop[level - 1],
      width: avtarSize / scale,
      height: avtarSize / scale,
      package: 'app_service_user',
    );
  }
}

/// 用户头像(传user模型)
class UserAavtarWidget<T extends UserBaseBean> extends StatelessWidget {
  final T userBean;
  final double outerCircleSize; // 外框直径
  final double outerCircleWidth; // 外框与内框间距(一般为0，即看起来只有一个框)
  final bool disableGoPersonalPage;
  final Function onTap; // 如果有实现，则响应外部的点击事件

  const UserAavtarWidget({
    Key? key,
    required this.outerCircleSize,
    this.outerCircleWidth = 0.0,
    required this.userBean,
    this.disableGoPersonalPage = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCircleAvatarWidget(
      outerCircleSize: outerCircleSize,
      outerCircleWidth: outerCircleWidth,
      avatarUrl: userBean?.avatar,
      userLevel: userBean?.consumerLevel ?? 0,
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        if (disableGoPersonalPage) {
          return;
        }
        RouterUtil.goUserPage(context, uid: userBean?.userId);
      },
    );
  }
}

class UserAvatarAndNickNameWidget<T extends UserBaseBean>
    extends StatelessWidget {
  final void Function() onTap;
  final T userBean;
  final double outerCircleSize; // 外框直径
  final double outerCircleWidth; // 外框与内框间距(一般为0，即看起来只有一个框)
  final Axis axis;

  final double avatarNicknameSpacing;

  final bool disableGoPersonalPage;

  final Color color;
  final EdgeInsetsGeometry padding;
  final TextStyle nicknameTextStyle;

  const UserAvatarAndNickNameWidget({
    Key? key,
    required this.outerCircleSize,
    this.outerCircleWidth = 0.0,
    required this.userBean,
    this.axis = Axis.horizontal,
    this.avatarNicknameSpacing = 4.0,
    this.disableGoPersonalPage = false,
    this.color, // 特别注意：不设置Color的话，onTap点击事件会无效
    this.padding,
    this.nicknameTextStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        color: color,
        child: _contentWidget,
      ),
    );
  }

  Widget get _contentWidget {
    if (axis == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatarWidget,
          SizedBox(width: avatarNicknameSpacing),
          _nicknameWidget,
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatarWidget,
          SizedBox(height: avatarNicknameSpacing),
          _nicknameWidget,
        ],
      );
    }
  }

  Widget get _avatarWidget {
    return UserAavtarWidget(
      outerCircleSize: outerCircleSize,
      outerCircleWidth: outerCircleWidth,
      userBean: userBean,
      disableGoPersonalPage: disableGoPersonalPage,
    );
  }

  Widget get _nicknameWidget {
    return Text(
      userBean.nickname ?? '',
      maxLines: 1,
      textAlign: TextAlign.left,
      style: nicknameTextStyle ??
          TextStyle(
            overflow: TextOverflow.ellipsis,
            color: const Color(0xff999999),
            fontSize: 10.w_pt_cj,
            fontWeight: FontWeight.normal,
          ),
    );
  }
}

class RouterUtil {
  static goUserPage(BuildContext context, {required String uid}) {
    // RouteManager.pushPage(
    //   context,
    //   RouteNames.spaceUserPage,
    //   arguments: {"id": uid},
    // );
  }
}

const Map<int, List<Color>> levelColors = {
  0: [Color(0xff93bece), Color(0xff93bece)],
  1: [Color(0xff93bece), Color(0xff93bece)],
  2: [Color(0xffe0c184), Color(0xffe0c184)],
  3: [Color(0xfff4a5b4), Color(0xfff4a5b4)],
  4: [Color(0xffd498f8), Color(0xffd498f8)],
  5: [
    Color(0xff5e78e5),
    Color(0xffb72cd8),
    Color(0xfff5555b),
    Color(0xffff7f00),
    Color(0xfffad126)
  ],
  6: [Color(0xff93bece), Color(0xff93bece)],
};

const List<String> _levelTop = [
  "images/level/level_top1.png",
  "images/level/level_top2.png",
  "images/level/level_top3.png",
  "images/level/level_top4.png",
  "images/level/level_top5.png",
  "images/level/level_top5.png",
];
const List<String> _levelCir = [
  "images/level/level_cir1.png",
  "images/level/level_cir1.png",
  "images/level/level_cir2.png",
  "images/level/level_cir3.png",
  "images/level/level_cir4.png",
  "images/level/level_cir5.png",
  "images/level/level_cir5.png",
];

/// 头像(传头像地址、点击事件等)
class AppCircleAvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final double outerCircleSize; // 外框直径
  final double outerCircleWidth; // 外框与内框间距(一般为0，即看起来只有一个框)
  final Function onTap;
  final int userLevel;

  const AppCircleAvatarWidget({
    Key? key,
    required this.outerCircleSize,
    this.outerCircleWidth = 0.0,
    required this.avatarUrl,
    this.onTap,
    this.userLevel = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double innerCircleSize = outerCircleSize - outerCircleWidth;
    return GestureDetector(
        onTap: onTap, // 确保外部传null时候可以透传事件
        child: Container(
          width: outerCircleSize,
          height: outerCircleSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(outerCircleSize * 0.5),
            ),
            border: (userLevel ?? 0) > 0 && outerCircleSize > 0
                ? Border.all(
                    width: ((outerCircleSize ~/ 8.9) / 2).w_pt_cj,
                    style: BorderStyle.none)
                : Border.all(width: outerCircleWidth, style: BorderStyle.none),
            image: (userLevel ?? 0) > 0
                ? DecorationImage(
                    image: AssetImage(
                      _levelCir[userLevel ?? 0],
                      package: 'app_service_user',
                    ),
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                  )
                : null,
          ),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(innerCircleSize * 0.5),
              ),
              // 这边不要改 再套一层会增加维护成本
              child: TolerantNetworkImage(
                imageUrl: avatarUrl ?? '',
                width: innerCircleSize,
                height: innerCircleSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
