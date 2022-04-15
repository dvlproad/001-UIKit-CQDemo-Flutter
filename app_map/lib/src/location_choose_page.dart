import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
export 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart'
    show BMFPoiInfo;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/common/colors.dart';

import 'dart:async';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:wish/common/locate_manager.dart';
import 'package:wish/widget/appbar_view.dart';

typedef LocateSelectCallBack = Function(BMFPoiInfo entity);

//39.965, 116.404北京
class LocationChoosePage extends StatefulWidget {
  final LocateSelectCallBack callBack;
  LocationChoosePage({
    Key key,
    @required this.callBack,
  }) : super(key: key);

  @override
  _LocationChoosePageState createState() => _LocationChoosePageState();
}

class _LocationChoosePageState extends State<LocationChoosePage> {
  /// 用户经纬度
  double _userLatitude = 39.965;
  double _userLongitude = 116.404;

  /// 移动经纬度
  double _moveLatitude = 39.965;
  double _moveLongitude = 116.404;

  bool _isLocateSuccess = false;

  List<BMFPoiInfo> _poiInfoList = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //开始定位
    LocateManager.instance.startLocation((LocateModel model) {
      _userLatitude = model.latitude;
      _userLongitude = model.longitude;
      // _stopLocation();
      _isLocateSuccess = true;
      _moveLatitude = model.latitude;
      _moveLongitude = model.longitude;
      _onTapSearch();
    });
  }

  /// 检索
  void _onTapSearch() async {
    // 构造检索参数
    BMFPoiNearbySearchOption poiNearbySearchOption = BMFPoiNearbySearchOption(
      keywords: <String>["办公楼", "小区", '餐饮', '酒店', "学校", "超市", "医院", "公交", '景点'],
      location: BMFCoordinate(_moveLatitude, _moveLongitude),
      radius: 500,
      isRadiusLimit: true,
      pageIndex: 0,
      pageSize: 20,
      scope: BMFPoiSearchScopeType.DETAIL_INFORMATION,
    );
// 检索实例
    BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
// 检索回调
    nearbySearch.onGetPoiNearbySearchResult(
        callback: (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
      print(
          'poi周边检索回调 errorCode = ${errorCode}  \n result = ${result?.toMap()}');
      setState(() {
        _poiInfoList = result.poiInfoList != null ? result.poiInfoList : [];
      });
    });
// 发起检索
    bool flag = await nearbySearch.poiNearbySearch(poiNearbySearchOption);
  }

  @override
  Widget build(BuildContext context) {
    BMFCoordinate center = BMFCoordinate(_userLatitude, _userLongitude);
    BMFMapOptions mapOptions = BMFMapOptions(
        mapType: BMFMapType.Standard,
        zoomLevel: 17,
        maxZoomLevel: 21,
        minZoomLevel: 4,
        logoPosition: BMFLogoPosition.LeftBottom,
        mapPadding: BMFEdgeInsets(top: 0, left: 0, right: 0, bottom: 0),
        overlookEnabled: true,
        overlooking: 0,
        center: center);
    BMFMapController myMapController;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 50.w,
            height: 44.w,
            alignment: Alignment.center,
            child: getBackWidget(context),
          ),
        ),
        title:
            Text("定位", style: TextStyle(color: color_222222, fontSize: 15.w)),
        backgroundColor: Color(0xFFEDF1F5),
        elevation: 0,
        brightness: Brightness.dark,
      ),
      body: Column(
        children: [
          (_isLocateSuccess == false)
              ? Container()
              : Container(
                  height: 300.w,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                          left: 0.w,
                          top: 0.w,
                          height: 300.w,
                          width: MediaQuery.of(context).size.width,
                          child: BMFMapWidget(
                            onBMFMapCreated: (controller) {
                              myMapController = controller;
                              myMapController.showUserLocation(true);
                              BMFCoordinate coordinate =
                                  BMFCoordinate(_userLatitude, _userLongitude);

                              BMFLocation location = BMFLocation(
                                  coordinate: coordinate,
                                  altitude: 0,
                                  horizontalAccuracy: 5,
                                  verticalAccuracy: -1.0,
                                  speed: -1.0,
                                  course: -1.0);
                              BMFUserLocation userLocation = BMFUserLocation(
                                location: location,
                              );
                              // myMapController.updateLocationData(userLocation);
                              myMapController
                                  .updateLocationData(userLocation)
                                  .then((e) {
                                print("e:${e}");
                              });

                              // BMFUserlocationDisplayParam displayParam = BMFUserlocationDisplayParam(
                              //     locationViewOffsetX: 0,
                              //     locationViewOffsetY: 0,
                              //     accuracyCircleFillColor: Colors.red,
                              //     accuracyCircleStrokeColor: Colors.blue,
                              //     isAccuracyCircleShow: true,
                              //     locationViewImage: 'resoures/animation_red.png',
                              //     locationViewHierarchy:
                              //     BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

                              // myMapController.updateLocationViewWithParam(displayParam);

                              // /// 地图加载回调
                              myMapController.setMapDidLoadCallback(
                                  callback: () {
                                print("setMapDidLoadCallback");

                                // /// 创建BMFMarker
                                // BMFMarker marker = BMFMarker(
                                //   position:
                                //       BMFCoordinate(_userLatitude, _userLongitude),
                                //   title: 'flutterMaker',
                                //   identifier: 'flutter_marker',
                                //   icon: 'images/mine/BaiduMap/icon_binding_point.png',
                                //   isLockedToScreen: true,
                                //   screenPointToLock: BMFPoint(
                                //       MediaQuery.of(context).size.width / 2, 300.w / 2),
                                //   canShowCallout: false,
                                // );
                                //
                                // /// 添加Marker
                                // myMapController.addMarker(marker);
                              });

                              /// 地图区域改变完成后会调用此接口
                              /// mapStatus 地图状态信息
                              /// regionChangeReason 地图改变原因
                              myMapController
                                  .setMapRegionDidChangeWithReasonCallback(
                                      callback: (BMFMapStatus mapStatus,
                                          BMFRegionChangeReason
                                              regionChangeReason) {
                                print("${mapStatus.targetGeoPt.latitude}");
                                print("${mapStatus.targetGeoPt.longitude}");
                                _moveLatitude = mapStatus.targetGeoPt.latitude;
                                _moveLongitude =
                                    mapStatus.targetGeoPt.longitude;
                                _onTapSearch();
                              });
                            },
                            mapOptions: mapOptions,
                          )),
                      Positioned(
                          top: (300.w - 30.w - 30.w) / 2,
                          height: 30.w,
                          width: 30.w,
                          child: Container(
                            // color:Colors.yellow,
                            child: Image(
                              image: AssetImage(
                                  'images/mine/BaiduMap/icon_binding_point.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ))
                    ],
                  ),
                ),
          Expanded(
            child: ListView.separated(
              itemCount: _poiInfoList.length,
              itemBuilder: (BuildContext context, int index) {
                BMFPoiInfo poiInfo = _poiInfoList[index];

                double latitude = 0.0;
                double longitude = 0.0;
                if (poiInfo.detailInfo != null &&
                    poiInfo.detailInfo.naviLocation != null) {
                  latitude = poiInfo.detailInfo.naviLocation.latitude ?? 0.0;
                  longitude = poiInfo.detailInfo.naviLocation.longitude ?? 0.0;
                }

                return InkWell(
                  splashColor: Colors.grey,
                  onTap: () {
                    // if (latitude == 0 || longitude == 0) {
                    //   ToastUtil.showMessage('当前经纬度为{$latitude,$longitude},请换个');
                    //   return;
                    // }
                    Navigator.of(context).pop();
                    if (widget.callBack != null) {
                      widget.callBack(poiInfo);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.w),
                        Text(
                          poiInfo.name,
                          style: TextStyle(color: Colors.black, fontSize: 14.w),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          poiInfo.address,
                          style: TextStyle(color: Colors.grey, fontSize: 12.w),
                        ),
                        SizedBox(height: 5.w),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey,
                  indent: 15.w,
                  endIndent: 15.w,
                  height: 1.w,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
