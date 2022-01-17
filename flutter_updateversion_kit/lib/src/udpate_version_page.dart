import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import './version_bean.dart';
import './download_file.dart';
import './update_version_notifier.dart';

class UpdateVersionPage extends StatefulWidget {
  final VersionBean versionBean;
  UpdateVersionPage({Key key, this.versionBean}) : super(key: key);
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
    DownLoadFile().stop(widget.versionBean.downloadUrl);
    _updateNotifier.dispose();
    _updateNotifier = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<UpdateNotifier>.value(
        value: _updateNotifier,
        child: Container(
          color: Color(0x99000000),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[_uploadDIalogBuild(), _progressBuild()],
          ),
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
    var _maxContentHeight = max(screenSize.height - 400, 180.0);
    double width = screenSize.height > screenSize.width ? 265 : 370;
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
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
                fontFamily: "iconfont", fontSize: 50.sp, color: Colors.black)),
      ),
    );
  }

  Widget _versionContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Html(
        data: widget.versionBean.isson,
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
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Container()),
          Text(
            "--",
            style: TextStyle(color: Colors.grey, fontSize: 18.sp),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "发现新版本 ${widget.versionBean.version}",
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "--",
            style: TextStyle(color: Colors.grey, fontSize: 18.sp),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _bottomMenu(double w) {
    return Container(
      height: 60,
      width: w,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Divider(height: 1.0),
          Container(
            height: 49,
            width: w,
            child: Row(
              children: <Widget>[
                _cancelBtn(w - 2),
                VerticalDivider(
                  width: 1,
                  indent: 10,
                ),
                _downloadBtn(w)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cancelBtn(double w) {
    return InkWell(
      child: Container(
        width: w / 2,
        alignment: Alignment.center,
        child: Text(
          "取消",
          style: TextStyle(color: Colors.black),
        ),
      ),
      onTap: () {
        print("取消升级");
        Navigator.pop(context);
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
    String url = widget.versionBean.downloadUrl;
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
    String _fileName = "dvlproad_" + widget.versionBean.version + ".apk";
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
