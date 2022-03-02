import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../flutter_updateversion_kit_adapt.dart';

import './version_bean.dart';
import './download_file.dart';
import './update_version_notifier.dart';
import './flex_width_buttons.dart';

class UpdateVersionPage extends StatefulWidget {
  final String version;
  final String buildNumber;
  final String updateLog;
  final String downloadUrl;
  final void Function() closeUpdateBlock;
  final void Function() skipUpdateBlock;
  final void Function() updateVersionBlock;
  final bool forceUpdate;

  UpdateVersionPage({
    Key key,
    this.version,
    this.buildNumber,
    this.updateLog,
    this.downloadUrl,
    this.closeUpdateBlock, // 点击'取消升级'执行的方法
    this.skipUpdateBlock, // 点击'跳过此版本'执行的方法
    this.updateVersionBlock, // 点击"立即升级”执行的方法(默认不传null，内部会自己处理,这里设置只是为了内部没处理完前点击时候跳到下载的网页)
    this.forceUpdate, // 是否是强制升级
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateVersionPageState();
  }
}

class _UpdateVersionPageState extends State<UpdateVersionPage> {
  UpdateNotifier _updateNotifier = UpdateNotifier();
  // final url = "https://xxx.com/files/app.apk";

  @override
  void dispose() {
    DownLoadFile().stop(widget.downloadUrl);
    _updateNotifier.dispose();
    _updateNotifier = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        alertViewBulider(context),
      ],
    );
  }

  Widget alertViewBulider(BuildContext context) {
    return ChangeNotifierProvider<UpdateNotifier>.value(
      value: _updateNotifier,
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[_uploadDIalogBuild()],
        ),
      ),
    );
  }

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
            padding: EdgeInsets.only(left: 50, right: 50),
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(child: Container()),
                  Text(
                    "下载进度：" + value.progress.toString() + "%",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: value.progress / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadDIalogBuild() {
    final screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.9;
    var _maxContentHeight = width * 1.2;
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      width: width,
      height: _maxContentHeight,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _updateInfo(_maxContentHeight)),
            _bottomMenu(width)
          ],
        ),
      ),
    );
  }

  Widget _updateInfo(var maxHeight) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
                <Widget>[_versionIcon(), _versionTitle(), _versionContent()]),
          ),
        )
      ],
    );
  }

  Widget _versionIcon() {
    return Center(
      child: RichText(
        text: TextSpan(
            text: ' \ue636 ',
            style: TextStyle(
              fontFamily: "iconfont",
              fontSize: 50.sp_cj,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget _versionContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        widget.updateLog ?? '',
        style: TextStyle(color: Colors.grey),
      ),
    );
    return Container(
      padding: EdgeInsets.all(10),
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
    String newVersion = widget.version;
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          Expanded(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              child: Text(
                "发现新版本 $newVersion",
                style: TextStyle(color: Colors.black, fontSize: 18.sp_cj),
              ),
            );
          })),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _bottomMenu(double w) {
    if (widget.forceUpdate == true) {
      return FlexWidthButtons(
        titles: ['立即升级'],
        onPressed: (buttonIndex) {
          print(buttonIndex);
          this._updateNotifier.setIsClickAble(false);
          _update();
        },
      );
    }

    return FlexWidthButtons(
      titles: ['关闭', '跳过此版本', '立即升级'],
      onPressed: (buttonIndex) {
        print(buttonIndex);

        if (buttonIndex == 0) {
          Navigator.pop(context);
          if (widget.closeUpdateBlock != null) {
            widget.closeUpdateBlock();
          }
        } else if (buttonIndex == 1) {
          Navigator.pop(context);
          if (widget.skipUpdateBlock != null) {
            widget.skipUpdateBlock();
          }
        } else if (buttonIndex == 2) {
          this._updateNotifier.setIsClickAble(false);
          _update();
        }
      },
    );
  }

  Widget _downloadBtn(double w) {
    return Consumer<UpdateNotifier>(
      builder: (context, value, child) => InkWell(
        child: Container(
          width: w / 2,
          alignment: Alignment.center,
          child: Text(
            value.updateBtn,
            style: TextStyle(color: Colors.black),
          ),
        ),
        onTap: () {
          if (value.isClickAble) {
            // todo 判断点击与否
            this._updateNotifier.setIsClickAble(false);
            _update();
            print("立即升级");
          }
        },
      ),
    );
  }

  void _update() async {
    if (widget.updateVersionBlock != null) {
      widget.updateVersionBlock();
      return;
    }

    String url = widget.downloadUrl;
    if (url != null || url != "") {
      if (Platform.isIOS) {
        this._downloadIos(url);
      } else {
        this._downloadAndroid(url);
      }
    }
  }

  void _downloadIos(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _downloadAndroid(String url) async {
    String _storePath = (await getExternalStorageDirectory()).path.toString();
    String _fileName = "dvlproad_" + widget.version + ".apk";
    String _savePath = _storePath + _fileName;
    File file = File(_savePath);
    if (await file.exists()) {
      _delFile(_savePath);
    }
    File tmpF = File(_storePath);
    if (!await tmpF.exists()) {
      Directory(_storePath).createSync();
    }
    await DownLoadFile().download(url, _savePath,
        onReceiveProgress: (received, total) {
      if (total != -1) {
        var progress = (received / total * 100).floor();
        if (progress == 0) {
          // todo loading判断
        }
        print("下载已接收:" +
            received.toString() +
            "总共：" +
            total.toString() +
            "进度：+$progress%");
        if (this._updateNotifier != null) {
          this._updateNotifier.setProgress(progress);
          this._updateNotifier.setIsHideProgress(false);
        }
      }
    }, done: () {
      // NotificationsManger.getInstance(context)
      //     .showNotificationWithNoSound("1440更新", "下载完成", _savePath);
      if (this._updateNotifier != null) {
        this._updateNotifier.setUpdateBtn("立即升级");
        this._updateNotifier.setIsClickAble(true);
        this._updateNotifier.setIsHideProgress(true);
      }

      _downloadDialogBuild(_savePath, "");
    }, failed: (e) {
      // NotificationsManger.getInstance(context)
      //     .showNotificationWithNoSound("1440更新", "下载失败", "");
      if (this._updateNotifier != null) {
        this._updateNotifier.setProgress(0);
        this._updateNotifier.setUpdateBtn("重新下载");
        this._updateNotifier.setIsClickAble(true);
        this._updateNotifier.setIsHideProgress(true);
      }
    });
  }

  void _delFile(String path) {
    Directory(path)
        .delete(recursive: true)
        .then((FileSystemEntity fileSystemEntity) {
      print('删除path' + fileSystemEntity.path);
    });
  }

  void _downloadDialogBuild(String path, String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("App下载"),
          content: Text("下载完成，是否马上安装？"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                this._updateNotifier.setProgress(0);
                this._updateNotifier.setUpdateBtn("立即升级");
                this._updateNotifier.setIsClickAble(true);
                this._updateNotifier.setIsHideProgress(true);
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () {
                this._updateNotifier.setProgress(0);
                this._updateNotifier.setUpdateBtn("立即升级");
                this._updateNotifier.setIsClickAble(true);
                this._updateNotifier.setIsHideProgress(true);
                OpenFile.open(path);
                Navigator.of(context).pop();
              },
              child: Text("确认"),
            )
          ],
        );
      },
    );
  }
}
