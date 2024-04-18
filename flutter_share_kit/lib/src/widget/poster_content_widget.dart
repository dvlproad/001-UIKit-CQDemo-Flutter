// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_image_basekit/flutter_image_kit.dart';
import 'package:extended_image/extended_image.dart';

import '../../flutter_share_kit_adapt.dart';
import '../base_share_singleton.dart';

class PosterDataModel {
  final String? posterImageUrl;
  final String? userImageUrl;
  final String qrCodeUrl;

  const PosterDataModel({
    this.posterImageUrl,
    this.userImageUrl,
    required this.qrCodeUrl, // 后台一定要返回二维码
  });
}

class PosterContentWidget extends StatefulWidget {
  final String posterImageUrl;
  final String userImageUrl;
  final Widget Function(
      {required double halfAvatarHeight,
      required double qrCodeWidgetWidth}) textContainerBuilder;
  final String appLogoPath;
  final Future<PosterDataModel?> Function() netPosterDataGetter;

  const PosterContentWidget({
    required this.posterImageUrl,
    required this.userImageUrl,
    required this.textContainerBuilder,
    required this.appLogoPath,
    required this.netPosterDataGetter,
    Key? key,
  }) : super(key: key);

  @override
  State<PosterContentWidget> createState() => _PosterContentWidgetState();
}

class _PosterContentWidgetState extends State<PosterContentWidget> {
  double posterImageWidth = 335.w_pt_cj;
  double posterImageHeight = 366.h_pt_cj;
  double avatarSize = 64.h_pt_cj;

  double leftOrRightPadding = 16.w_pt_cj;
  double bottomPadding = 16.h_pt_cj;

  String _userImageUrl = "";
  String _posterImageUrl = "";
  String? _qrCodeWebUrl;
  @override
  void initState() {
    super.initState();

    _userImageUrl = widget.userImageUrl;
    _posterImageUrl = widget.posterImageUrl;

    widget.netPosterDataGetter().then((PosterDataModel? posterDataModel) {
      if (posterDataModel == null) {
        return;
      }
      setState(() {
        if (posterDataModel.userImageUrl != null &&
            posterDataModel.userImageUrl!.isNotEmpty) {
          _userImageUrl = posterDataModel.userImageUrl!;
        }

        if (posterDataModel.posterImageUrl != null &&
            posterDataModel.posterImageUrl!.isNotEmpty) {
          _posterImageUrl = posterDataModel.posterImageUrl!;
        }

        _qrCodeWebUrl = posterDataModel.qrCodeUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 535.h_pt_cj,
      width: posterImageWidth,
      child: Stack(
        children: [
          Column(
            children: [
              _renderPosterImageWidget(),
              _renderPosterContent(),
            ],
          ),
          _renderPositionedAvatar(),
          _renderPositionedAppLog(),
          _renderPositionedQRCode(),
        ],
      ),
    );
  }

  _renderPosterImageWidget() {
    bool isNetworkImage = _posterImageUrl.startsWith("http");

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.w_pt_cj),
        topRight: Radius.circular(15.w_pt_cj),
      ),
      // clipBehavior: Clip.hardEdge,
      child: isNetworkImage
          ? ExtendedImage.network(
              _posterImageUrl,
              width: posterImageWidth,
              height: posterImageHeight,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(
                Radius.circular(5.w_pt_cj),
              ),
              loadStateChanged: (ExtendedImageState value) {
                return _loadStateChanged(value);
              },
            )
          : ExtendedImage.asset(
              _posterImageUrl,
              width: posterImageWidth,
              height: posterImageHeight,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(
                Radius.circular(5.w_pt_cj),
              ),
              loadStateChanged: (ExtendedImageState value) {
                return _loadStateChanged(value);
              },
            ),
    );
  }

  Widget? _loadStateChanged(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.loading) {
      Widget loadingWidget = Container(
        alignment: Alignment.center,
        color: Colors.white,
      );
      return loadingWidget;
    } else if (state.extendedImageLoadState == LoadState.completed) {
      //
    } else if (state.extendedImageLoadState == LoadState.failed) {
      return Container(
        alignment: Alignment.center,
        // color: Colors.red,
        child: Image.asset(
          BaseShareSingleton.placeholderImageName ?? "",
          width: posterImageWidth,
          height: posterImageHeight,
          fit: BoxFit.cover,
        ),
      );
    }
    return null;
  }

  _renderPosterContent() {
    return Expanded(
      child: Container(
        width: posterImageWidth,
        padding: EdgeInsets.only(
          left: leftOrRightPadding,
          right: leftOrRightPadding,
          bottom: bottomPadding + appLogoWidgetHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.w_pt_cj),
            bottomRight: Radius.circular(15.w_pt_cj),
          ),
        ),
        child: widget.textContainerBuilder(
          halfAvatarHeight: avatarSize / 2,
          qrCodeWidgetWidth: qrCodeImageSize,
        ),
      ),
    );
  }

  _renderPositionedAvatar() {
    double innerAvatarSize = avatarSize - 2.w_pt_cj;
    return Positioned(
      top: posterImageHeight - avatarSize / 2,
      left: leftOrRightPadding,
      // child: Container(
      //   color: Colors.green,
      //   height: avatarSize,
      //   width: avatarSize,
      // ),
      child: Container(
        width: avatarSize,
        height: avatarSize,
        padding: EdgeInsets.all(2.w_pt_cj),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(avatarSize / 2.0)),
        ),
        child: TolerantNetworkImage(
          imageUrl: _userImageUrl,
          width: innerAvatarSize,
          height: innerAvatarSize,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(innerAvatarSize / 2),
        ),
      ),
    );
  }

  double appLogoWidgetHeight = 16.h_pt_cj;
  _renderPositionedAppLog() {
    return Positioned(
      bottom: bottomPadding,
      left: leftOrRightPadding,
      child: Image.asset(
        widget.appLogoPath,
        width: 61.w_pt_cj,
        height: appLogoWidgetHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  double qrCodeImageSize = 70.w_pt_cj;
  // double qrCodeWidgetHeight = 70.w_pt_cj + (4 + 12).w_pt_cj;
  _renderPositionedQRCode() {
    return Positioned(
      bottom: bottomPadding,
      right: leftOrRightPadding,
      child: Container(
        // color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: qrCodeImageSize,
              height: qrCodeImageSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.w_pt_cj)),
                color: Colors.white,
              ),
              child: _qrCodeWebUrl == null
                  ? Container()
                  : QrImageView(
                      data: _qrCodeWebUrl!,
                      padding: EdgeInsets.zero,
                      errorStateBuilder:
                          (BuildContext context, Object? object) {
                        return Container();
                      },
                    ),
            ),
            SizedBox(height: 4.w_pt_cj),
            Text(
              '扫码查看',
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
                fontSize: 13.w_pt_cj,
                color: const Color(0xFF8b8b8b),
              ),
            )
          ],
        ),
      ),
    );
  }
}
