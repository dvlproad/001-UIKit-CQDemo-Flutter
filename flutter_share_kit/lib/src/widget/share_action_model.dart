/*
 * @Author: dvlproad
 * @Date: 2024-03-04 15:52:32
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-08 17:19:17
 * @Description: 
 */
import 'dart:ui';

class BaseActionModel {
  final String imageName;
  final String? imagePackage;
  final String title;
  final Color titleColor;
  final void Function() handle;

  BaseActionModel({
    required this.imageName,
    this.imagePackage,
    required this.title,
    this.titleColor = const Color(0xff333333),
    required this.handle,
  });

  static BaseActionModel im({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/share_im.png',
      imagePackage: "flutter_share_kit",
      title: '私信',
      handle: handle,
    );
  }

  static BaseActionModel wechat({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/share_wechat.png',
      imagePackage: "flutter_share_kit",
      title: '微信',
      handle: handle,
    );
  }

  static BaseActionModel timeline({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/share_timeline.png',
      imagePackage: "flutter_share_kit",
      title: '朋友圈',
      handle: handle,
    );
  }

  static BaseActionModel poster({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/share_poster.png',
      imagePackage: "flutter_share_kit",
      title: '生成海报',
      handle: handle,
    );
  }

  static BaseActionModel copyLink({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/copy_link.png',
      imagePackage: "flutter_share_kit",
      title: '复制链接',
      titleColor: const Color(0xffA3A3A3),
      handle: handle,
    );
  }

  static BaseActionModel report({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/report.png',
      imagePackage: "flutter_share_kit",
      title: '举报',
      titleColor: const Color(0xffA3A3A3),
      handle: handle,
    );
  }

  static BaseActionModel editMeans({required void Function() handle}) {
    return BaseActionModel(
      imageName: 'assets/edit_means_icon.png',
      imagePackage: "flutter_share_kit",
      title: '编辑资料',
      titleColor: const Color(0xffA3A3A3),
      handle: handle,
    );
  }

  static BaseActionModel block({
    required bool isBlock,
    required void Function() handle,
  }) {
    return BaseActionModel(
      imageName: !isBlock ? 'assets/block.png' : 'assets/block_cancel.png',
      imagePackage: "flutter_share_kit",
      title: !isBlock ? '拉黑' : '取消拉黑',
      titleColor: const Color(0xffA3A3A3),
      handle: handle,
    );
  }
}
