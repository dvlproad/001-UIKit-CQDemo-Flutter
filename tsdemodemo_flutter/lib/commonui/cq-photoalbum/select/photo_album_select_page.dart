import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/cq-photo-list.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_datasource_notifier.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_select_notifier.dart';

class PhotoAlbumPage extends StatefulWidget {
  PhotoAlbumPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PhotoAlbumPageState();
  }
}

class _PhotoAlbumPageState extends State<PhotoAlbumPage> {
  PhotoAlbumNotifier _photoAlbumNotifier = PhotoAlbumNotifier();

  PhotoAlbumSelectNotifier _photoAlbumSelectNotifier =
      PhotoAlbumSelectNotifier();

  EasyRefreshController _easyCtrl;

  @override
  void dispose() {
    _photoAlbumNotifier.dispose();
    _easyCtrl.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _easyCtrl = EasyRefreshController();

    _photoAlbumNotifier.page = 0;
    _photoAlbumNotifier.loadAssets().then((value) {
      _easyCtrl.finishRefresh();
      if (value == PhotoAlbumAssetState.success) {
        _photoAlbumSelectNotifier.addSelectIndex(0);
      }
    }).catchError((onError) {
      _easyCtrl.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Expanded(child: buildBodyGrid()),
        ],
      ),
    );
  }

  //相册宫格缩略图
  Widget buildBodyGrid() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotoAlbumNotifier>.value(
          value: _photoAlbumNotifier,
        ),
        ChangeNotifierProvider<PhotoAlbumSelectNotifier>.value(
          value: _photoAlbumSelectNotifier,
        ),
      ],
      child: Consumer2<PhotoAlbumNotifier, PhotoAlbumSelectNotifier>(
        builder: (context, photoAlbumNotifier, photoAlbumSelectNotifier, _) {
          return Container(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              controller: _easyCtrl,
              // header: ClassicalHeader(),
              footer: C1440RefreshFooter(
                noMoreWidget: Text(
                  "没有更多媒体了",
                  style: TextStyle(
                    color: Color(0xFFBFBFBF),
                  ),
                ),
              ),

              child: CQPhotoList(
                photoAlbumAssets: _photoAlbumNotifier.assets,
                photoAlbumSelectNotifier: photoAlbumSelectNotifier,
                prefixWidget: Container(color: Colors.red),
                // suffixWidget: Container(color: Colors.green),
              ),
              onLoad: () async {
                loadMoreData();
              },
            ),
          );
        },
      ),
    );
  }

  void loadMoreData() {
    _photoAlbumNotifier.loadAssets().then((value) {
      _easyCtrl.finishLoad();
    }).catchError((onError) {
      _easyCtrl.finishLoad();
    });
  }
}
