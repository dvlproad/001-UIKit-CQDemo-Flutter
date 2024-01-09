// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import './download_file.dart';
import './download_util.dart';
import './update_version_notifier.dart';
import './flex_width_buttons.dart';

class UpdateVersionPage extends StatefulWidget {
  static bool isUpdateWindowShowing = false;

  final String version;
  final String buildNumber;
  final String? updateLog;
  final String downloadUrl;
  final void Function() closeUpdateBlock;
  final void Function() skipUpdateBlock;
  final void Function() notNowBlock;
  final void Function() updateVersionBlock;
  final bool forceUpdate;

  const UpdateVersionPage({
    Key? key,
    required this.version,
    required this.buildNumber,
    this.updateLog,
    required this.downloadUrl,
    required this.closeUpdateBlock, // 点击'取消升级'执行的方法
    required this.notNowBlock,
    required this.skipUpdateBlock, // 点击'跳过此版本'执行的方法
    required this.updateVersionBlock, // 点击"立即升级”执行的方法(默认不传null，内部会自己处理,这里设置只是为了内部没处理完前点击时候跳到下载的网页)
    this.forceUpdate = false, // 是否是强制升级
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UpdateVersionPageState();
  }
}

class UpdateVersionPageState extends State<UpdateVersionPage> {
  final UpdateNotifier _updateNotifier = UpdateNotifier();

  // final url = "https://xxx.com/files/app.apk";

  late String _newVersion;
  late String _buildNumber;
  late String _updateLog;

  @override
  void dispose() {
    DownLoadFile().stop(widget.downloadUrl);
    _updateNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _newVersion = widget.version;
    _buildNumber = widget.buildNumber;
    _updateLog = widget.updateLog ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            alertViewBulider(context),
          ],
        ),
      ),
    );
  }

  updateData({
    required String newVersion,
    required String buildNumber,
    required String updateLog,
  }) {
    setState(() {
      _newVersion = newVersion;
      _buildNumber = buildNumber;
      _updateLog = updateLog;
    });
  }

  Widget alertViewBulider(BuildContext context) {
    return ChangeNotifierProvider<UpdateNotifier>.value(
      value: _updateNotifier,
      child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: _uploadDialogBuild()),
    );
  }

  // ignore: unused_element
  Widget _progressBuild() {
    return Consumer<UpdateNotifier>(
      builder: (context, value, child) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: Offstage(
          offstage: value.isHideProgress,
          // offstage: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(child: Container()),
                  Text(
                    "下载进度：" + value.progress.toString() + "%",
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: value.progress / 100,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue)),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadDialogBuild() {
    final screenSize = MediaQuery.of(context).size;
    double width = screenSize.width - 86;
    var _maxContentHeight = width * 1.1;
    if (_maxContentHeight > screenSize.height * 0.35) {
      _maxContentHeight = screenSize.height * 0.35;
    }
    return Column(
      children: [
        Container(
          width: width,
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: _topIcon,
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          width: width,
          height: _maxContentHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Stack(
                children: [_updateInfo(_maxContentHeight), _shadowCover()],
              )),
              _new_bottomMenu(width),
            ],
          ),
        )
      ],
    );
  }

  Widget _shadowCover() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 67,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00FFFFFF), Colors.white],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateInfo(var maxHeight) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Material(child: _versionTitle()),
                Material(child: _versionContent()),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get _topIcon {
    return Image.asset(
      "assets/images/icon_update_top.png",
      package: 'flutter_updateversion_kit',
    );
  }

  Widget _versionContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 15),
      child: Text(
        _updateLog,
        style: const TextStyle(color: Colors.grey),
      ),
    );
    // ignore: dead_code
    return Container(
      padding: const EdgeInsets.all(10),
      child: Html(
        data: widget.updateLog ?? '',
        style: {
          "div": Style(color: Colors.grey),
          "b": Style(color: Colors.grey),
          "p": Style(color: Colors.grey),
          "h1": Style(color: Colors.grey),
          "h2": Style(color: Colors.grey),
        },
      ),
    );
  }

  Widget _versionTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 24, right: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Hi～发现了新版本咯！",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFF69368), Color(0xFFE87F52)]),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              _buildNumber,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  /// 当前新版按钮
  Widget _new_bottomMenu(double w) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.forceUpdate
            ? [
                Expanded(child: _updateButton(context)),
              ]
            : [
                Expanded(child: _closeButton(context)),
                Container(width: 10),
                Expanded(child: _updateButton(context)),
              ],
      ),
    );
  }

  Widget _updateButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _updateNow(context);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFF69368), Color(0xFFE87F52)]),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 36,
        child: const Text(
          "马上更新",
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.notNowBlock();
        UpdateVersionPage.isUpdateWindowShowing = false;
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // ignore: prefer_const_constructors
          color: Color(0xFFffffff),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFb8b8b8),
            width: 1,
          ),
        ),
        height: 36,
        child: const Text(
          "暂不更新",
          style: TextStyle(
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w500,
            color: Color(0xFF8b8b8b),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _downloadBtn(BuildContext context, double w) {
    return Consumer<UpdateNotifier>(
      builder: (context, value, child) => InkWell(
        child: Container(
          width: w / 2,
          alignment: Alignment.center,
          child: Text(
            value.updateBtn,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        onTap: () {
          if (value.isClickAble) {
            // todo 判断点击与否
            _updateNow(context);
          }
        },
      ),
    );
  }

  /// 旧版按钮
  // ignore: unused_element
  Widget _old_bottomMenu(BuildContext context, double w) {
    if (widget.forceUpdate == true) {
      return FlexWidthButtons(
        titles: const ['立即升级'],
        onPressed: (int buttonIndex) {
          // debugPrint("$buttonIndex");
          _updateNow(context);
        },
      );
    }

    return FlexWidthButtons(
      titles: const ['关闭', '跳过此版本', '立即升级'],
      onPressed: (buttonIndex) {
        debugPrint("$buttonIndex");

        if (buttonIndex == 0) {
          widget.closeUpdateBlock();
          UpdateVersionPage.isUpdateWindowShowing = false;
        } else if (buttonIndex == 1) {
          _skipUpdate(context);
        } else if (buttonIndex == 2) {
          _updateNow(context);
        }
      },
    );
  }

  void _skipUpdate(BuildContext context) {
    String url = widget.downloadUrl;
    DownloadUtil.skipUpdateAndroid(url);

    widget.skipUpdateBlock();
    UpdateVersionPage.isUpdateWindowShowing = false;
  }

  void _updateNow(BuildContext context) async {
    _updateNotifier.setIsClickAble(false);
    widget.updateVersionBlock();
    debugPrint("立即升级");

    String url = widget.downloadUrl;
    if (Platform.isIOS) {
      DownloadUtil.launchAppDownloadUrl(url);
    } else {
      DownloadUtil.downloadAndroid(
        url,
        forceUpdate: widget.forceUpdate,
        version: widget.version,
        buildNumber: widget.buildNumber,
        /*
        onReceiveProgress: (int progress) {
          _updateNotifier.setProgress(progress);
          _updateNotifier.setIsHideProgress(false);
        },
        done: (String savePath) {
          // NotificationsManger.getInstance(context)
          //     .showNotificationWithNoSound("1440更新", "下载完成", _savePath);
          _updateNotifier.setUpdateBtn("立即升级");
          _updateNotifier.setIsClickAble(true);
          _updateNotifier.setIsHideProgress(true);

          _downloadDialogBuild(context, savePath, "");
        },
        failed: () {
          // NotificationsManger.getInstance(context)
          //     .showNotificationWithNoSound("1440更新", "下载失败", "");
          _updateNotifier.setProgress(0);
          _updateNotifier.setUpdateBtn("重新下载");
          _updateNotifier.setIsClickAble(true);
          _updateNotifier.setIsHideProgress(true);
        },
        */
      );
    }
  }

  // ignore: unused_element
  void _downloadDialogBuild(BuildContext context, String path, String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("App下载"),
          content: const Text("下载完成，是否马上安装？"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _updateNotifier.setProgress(0);
                _updateNotifier.setUpdateBtn("立即升级");
                _updateNotifier.setIsClickAble(true);
                _updateNotifier.setIsHideProgress(true);
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                _updateNotifier.setProgress(0);
                _updateNotifier.setUpdateBtn("立即升级");
                _updateNotifier.setIsClickAble(true);
                _updateNotifier.setIsHideProgress(true);
                OpenFile.open(path);
              },
              child: const Text("确认"),
            )
          ],
        );
      },
    );
  }
}
